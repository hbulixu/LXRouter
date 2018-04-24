//
//  LXParamsInfoTree.m
//  LXRouter
//
//  Created by 58 on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXParamsInfoTree.h"
#import "TypeAnnotation.h"
#import <objc/runtime.h>
#import "NSObject+LXJsonModel.h"
@implementation LXParamsInfoTree

+ (id)genFuncCommentsWithClass:(Class) clz
{
    unsigned int methodCount = 0;
    objc_property_t *propertys = class_copyPropertyList(clz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        objc_property_t propety = propertys[i];
        NSString *name = [NSString stringWithCString:property_getName(propety) encoding:NSUTF8StringEncoding];
        
        NSString *propAttrs = [[NSString alloc] initWithCString:property_getAttributes(propety) encoding:NSUTF8StringEncoding];
        
        NSRange range = [propAttrs rangeOfString:@"@\".*\"" options:NSRegularExpressionSearch];
        
        if (range.location != NSNotFound) {
            range.location += 2;
            range.length -= 3;
            
            NSString *typeName = [propAttrs substringWithRange:range];
            if ([typeName isEqualToString:@"TypeAnnotation"]) {
                
                NSRange commetsRange = [name rangeOfString:@"FCComments_"];
                if (commetsRange.location !=NSNotFound) {
                    NSArray * array =  [name componentsSeparatedByString:@"_"];
                    if (array.count == 3) {
                        
                        NSString * comments = array[1];
                        if (comments) {
                            return comments;
                        }
                    }
                }
                
            }
            
        }
    }
    return nil;
    
}


+ (id)genParamsInfoTreeWithClass:(Class) clz
{
    
    id json = classToInfoTreeRecursive(clz,0,nil);
    if ([json isKindOfClass:[NSArray class]]) {
        return json;
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    return nil;
}

static id classToInfoTreeRecursive(Class clz, int level,NSString * fatherKey)
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
            if (![NSObject isClassFromFoundation:NSClassFromString(typeName)]) {
                
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
                    
                    continue;
                    
                    
                }else //自定义类
                {
                    id value = classToInfoTreeRecursive(NSClassFromString(typeName),level,name);
                    if (value) {
                        annotation.child = value;
                    }
                }
                
            }else//系统Foundation类
            {
                //array 要特殊处理一下
                if(([typeName isEqualToString:NSStringFromClass([NSArray class])] || [typeName isEqualToString:NSStringFromClass([NSMutableArray class])]) && annotation.protocolClass)
                {
                    id value = classToInfoTreeRecursive(annotation.protocolClass,level,name);
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
