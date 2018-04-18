//
//  LXJsonValidateTools.m
//  LXRouter
//
//  Created by 58 on 2018/4/17.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXJsonValidateTools.h"
#import "TypeAnnotation.h"
#import <objc/runtime.h>
static NSSet *foundationClasses_;
@implementation LXJsonValidateTools

+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] ) return YES;
    
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

+ (NSError *)validateJson:(id)json WithValidateObject:(id)validateObject
{
    if ( [validateObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = json;
        NSDictionary * validator = validateObject;
        NSError * error = nil;
        NSEnumerator * enumerator = [validator keyEnumerator];
        NSString * key ;
        while ((key = [enumerator nextObject])!=nil) {
            id format = validator[key];
            id value = dict[key];
            if ([format isKindOfClass:[NSDictionary class]] || [format isKindOfClass:[NSArray class]]) {
                error = [self validateJson:value WithValidateObject:format];
                if (error) {
                    break;
                }
            }else
            {
                if (![format isKindOfClass:[TypeAnnotation class]])
                {
                    error = [NSError errorWithDomain:@"validateObject error" code:-1 userInfo:nil];
                    return error;
                }
                
                TypeAnnotation * annotation = (TypeAnnotation *)format;
                if (annotation.required && (!value || [value isKindOfClass:[NSNull class]])) {
                    error = [NSError errorWithDomain:[NSString stringWithFormat:@"need value for key [%@]",key] code:-2 userInfo:nil];
                    return error;
                }
            }
        }
        return error;
    }else if( [validateObject isKindOfClass:[NSArray class]])
    {
        NSError * error = nil;
        NSArray * validatorArray = (NSArray *)validateObject;
        if (validatorArray.count > 0) {
            NSArray * array = json;
            NSDictionary * validator = validatorArray[0];
            
            if (!array || array.count == 0) {
                error = [self validateJson:nil WithValidateObject:validator];
                if (!error) {
                    return error;
                }
            }
            for (id item in array) {
                error = [self validateJson:item WithValidateObject:validator];
                if (!error) {
                    return error;
                }
            }
        }
        return error;
    }else{
        NSError * error = nil;
        if (![validateObject isKindOfClass:[TypeAnnotation class]])
        {
            error = [NSError errorWithDomain:@"validateObject error" code:-1 userInfo:nil];
            return error;
        }
        TypeAnnotation * annotation = (TypeAnnotation *)validateObject;
        if (annotation.required && (!json || [json isKindOfClass:[NSNull class]])) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"need value for key [%@]",annotation.keyName] code:-2 userInfo:nil];
        }
        return error;
    }
}

static id classToJsonRecursive(Class clz)
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:64];
    unsigned int methodCount = 0;
    objc_property_t *propertys = class_copyPropertyList(clz, &methodCount);
    
    TypeAnnotation * annotation = [TypeAnnotation new];
    
    for (unsigned int i = 0; i < methodCount; i++) {
        objc_property_t propety = propertys[i];
        
        NSString *name = [NSString stringWithCString:property_getName(propety) encoding:NSUTF8StringEncoding];
        
        NSString *propAttrs = [[NSString alloc] initWithCString:property_getAttributes(propety) encoding:NSUTF8StringEncoding];
        
        NSRange range = [propAttrs rangeOfString:@"@\".*\"" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            range.location += 2;
            range.length -= 3;
            NSString *typeName = [propAttrs substringWithRange:range];
            //排除基本类
            if (![LXJsonValidateTools isClassFromFoundation:NSClassFromString(typeName)]) {
                
                //注解类
                if ([typeName isEqualToString:@"TypeAnnotation"]) {
                    
                    NSRange paramRange =[name rangeOfString:@"paramRequired_"];
                    if (paramRange.location != NSNotFound) {
                        annotation.required = YES;
                        continue;
                    }
                    NSRange protocolRange = [name rangeOfString:@"propertyProtocol_"];
                    if (protocolRange.location !=NSNotFound) {
                        NSArray * array =  [name componentsSeparatedByString:@"_"];
                        if (array.count == 3) {
                            
                            Class protocolClass = NSClassFromString(array[1]);
                            if (protocolClass) {
                                annotation.protocolClass = protocolClass;
                            }
                        }
                        continue;
                    }
                    
                    NSRange commetsRange = [name rangeOfString:@"PRComments_"];
                    if (commetsRange.location !=NSNotFound) {
                        NSArray * array =  [name componentsSeparatedByString:@"_"];
                        if (array.count == 3) {
                            
                            NSString * comments = array[1];
                            if (comments) {
                                annotation.comments = comments;
                            }
                        }
                        continue;
                    }
                    
                }else //自定义类
                {
                    id value = classToJsonRecursive(NSClassFromString(typeName));
                    if (value) {
                        
                        [result setObject:value forKey:name];
                        annotation = [TypeAnnotation new];
                        continue;
                    }
                }
                
            }else//系统Foundation类
            {
                //array 要特殊处理一下
                if(([typeName isEqualToString:NSStringFromClass([NSArray class])] || [typeName isEqualToString:NSStringFromClass([NSMutableArray class])]) && annotation.protocolClass)
                {
                    id value = classToJsonRecursive(annotation.protocolClass);
                    if (value) {
                        NSArray * array = [NSArray arrayWithObjects:value, nil];
                        [result setObject:array forKey:name];
                        annotation = [TypeAnnotation new];
                        continue;
                    }
                }
                annotation.typeName = typeName;
                
            }
        }
        annotation.keyName = name;
        [result setObject:annotation forKey:name];
        annotation = [TypeAnnotation new];
        
    }
    free(propertys);
    return result;
}

//通过类属性和注解返回json，key和必输项
+ (nullable id)genValidateObjectWithClass:(Class) clz
{
    id json = classToJsonRecursive(clz);
    if ([json isKindOfClass:[NSArray class]]) {
        return json;
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    return nil;
}

+ (NSError *)validateJson:(id)json WithClass:(Class)clz
{
    id validateObject = [ LXJsonValidateTools genValidateObjectWithClass:clz];
    NSLog(@"%@",validateObject);
    return [LXJsonValidateTools validateJson:json WithValidateObject:validateObject];
}

+ (NSError *)newValidateJson:(id)json WithClass:(Class)clz
{

    id validateObject = [ LXJsonValidateTools newGenValidateObjectWithClass:clz];
    NSLog(@"%@",validateObject);
    return [LXJsonValidateTools newValidateJson:json WithValidateObject:validateObject];
}

+ (NSError *)newValidateJson:(id)json WithValidateObject:(id)validateObject
{
    if ( [validateObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = json;
        NSDictionary * validator = validateObject;
        NSError * error = nil;
        NSEnumerator * enumerator = [validator keyEnumerator];
        NSString * key ;
        while ((key = [enumerator nextObject])!=nil) {
            TypeAnnotation * format = validator[key];
            id value = dict[key];
            
            if ( [format isKindOfClass:[TypeAnnotation class]] && ([format.child isKindOfClass:[NSDictionary class]] || [format.child isKindOfClass:[NSArray class]])) {
                
                if (format.required && (!value || [value isKindOfClass:[NSNull class]])) {
                    error = [NSError errorWithDomain:[NSString stringWithFormat:@"need value for key [%@ %@]",format.fatherKey?:@"",format.keyName] code:-2 userInfo:nil];
                    if (error) {
                        break;
                    }
                }
                error = [self newValidateJson:value WithValidateObject:format.child];
                if (error) {
                    break;
                }
            }else
            {
               error = [self newValidateJson:value WithValidateObject:format];
                if (error) {
                    break;
                }
            }
        }
        return error;
    }else if( [validateObject isKindOfClass:[NSArray class]])
    {
        NSError * error = nil;
        NSArray * validatorArray = (NSArray *)validateObject;
        if (validatorArray.count > 0) {
            NSArray * array = json;
            NSDictionary * validator = validatorArray[0];
            
            if (!array || array.count == 0) {
                error = [self validateJson:nil WithValidateObject:validator];
                if (!error) {
                    return error;
                }
            }
            for (id item in array) {
                error = [self validateJson:item WithValidateObject:validator];
                if (!error) {
                    return error;
                }
            }
        }
        return error;
    }else{
        NSError * error = nil;
        if (![validateObject isKindOfClass:[TypeAnnotation class]])
        {
            error = [NSError errorWithDomain:@"validateObject error" code:-1 userInfo:nil];
            return error;
        }
        TypeAnnotation * annotation = (TypeAnnotation *)validateObject;
        if (annotation.required && (!json || [json isKindOfClass:[NSNull class]])) {
            error = [NSError errorWithDomain:[NSString stringWithFormat:@"need value for key [%@ %@]",annotation.fatherKey?:@"", annotation.keyName] code:-2 userInfo:nil];
        }
        return error;
    }
}
+ (nullable id)newGenValidateObjectWithClass:(Class) clz
{
    
    id json = newClassToJsonRecursive(clz,0,nil);
    if ([json isKindOfClass:[NSArray class]]) {
        return json;
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    return nil;
}

static id newClassToJsonRecursive(Class clz, int level,NSString * fatherKey)
{
    level++;
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:64];
    unsigned int methodCount = 0;
    objc_property_t *propertys = class_copyPropertyList(clz, &methodCount);
    
    TypeAnnotation * annotation = [TypeAnnotation new];
    annotation.level = level;
    for (unsigned int i = 0; i < methodCount; i++) {
        objc_property_t propety = propertys[i];
        
        NSString *name = [NSString stringWithCString:property_getName(propety) encoding:NSUTF8StringEncoding];
        
        NSString *propAttrs = [[NSString alloc] initWithCString:property_getAttributes(propety) encoding:NSUTF8StringEncoding];
        
        NSRange range = [propAttrs rangeOfString:@"@\".*\"" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            range.location += 2;
            range.length -= 3;
            NSString *typeName = [propAttrs substringWithRange:range];
            //排除基本类
            if (![LXJsonValidateTools isClassFromFoundation:NSClassFromString(typeName)]) {
                
                //注解类
                if ([typeName isEqualToString:@"TypeAnnotation"]) {
                    
                    NSRange paramRange =[name rangeOfString:@"paramRequired_"];
                    if (paramRange.location != NSNotFound) {
                        annotation.required = YES;
                        continue;
                    }
                    NSRange protocolRange = [name rangeOfString:@"propertyProtocol_"];
                    if (protocolRange.location !=NSNotFound) {
                        NSArray * array =  [name componentsSeparatedByString:@"_"];
                        if (array.count == 3) {
                            
                            Class protocolClass = NSClassFromString(array[1]);
                            if (protocolClass) {
                                annotation.protocolClass = protocolClass;
                            }
                        }
                        continue;
                    }
                    
                    NSRange commetsRange = [name rangeOfString:@"PRComments_"];
                    if (commetsRange.location !=NSNotFound) {
                        NSArray * array =  [name componentsSeparatedByString:@"_"];
                        if (array.count == 3) {
                            
                            NSString * comments = array[1];
                            if (comments) {
                                annotation.comments = comments;
                            }
                        }
                        continue;
                    }
                    
                }else //自定义类
                {
                    id value = newClassToJsonRecursive(NSClassFromString(typeName),level,name);
                    if (value) {
                        annotation.child = value;
                    }
                }
                
            }else//系统Foundation类
            {
                //array 要特殊处理一下
                if(([typeName isEqualToString:NSStringFromClass([NSArray class])] || [typeName isEqualToString:NSStringFromClass([NSMutableArray class])]) && annotation.protocolClass)
                {
                    id value = newClassToJsonRecursive(annotation.protocolClass,level,name);
                    if (value) {
                        NSArray * array = [NSArray arrayWithObjects:value, nil];
                        annotation.child = array;
                    }
                }
                
            }
            annotation.typeName = typeName;
        }
        annotation.keyName = name;
        annotation.fatherKey = fatherKey;
        annotation.level = level;
        [result setObject:annotation forKey:name];
        annotation = [TypeAnnotation new];

    }
    free(propertys);
    return result;
}


@end
