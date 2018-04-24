//
//  LXRouterInputValidate.m
//  LXRouter
//
//  Created by 58 on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouterInputValidate.h"
#import "LXParamsInfoTree.h"
#import "TypeAnnotation.h"

@implementation LXRouterInputValidate

+ (NSError *)validateJson:(id)json WithClass:(Class)clz
{
    
    id validateObject = [ LXParamsInfoTree genParamsInfoTreeWithClass:clz];
    NSLog(@"%@",validateObject);
    return [LXRouterInputValidate validateJson:json WithValidateObject:validateObject];
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
            TypeAnnotation * format = validator[key];
            id value = dict[key];
            
            if ( [format isKindOfClass:[TypeAnnotation class]] && ([format.child isKindOfClass:[NSDictionary class]] || [format.child isKindOfClass:[NSArray class]])) {
                
                if (format.required && (!value || [value isKindOfClass:[NSNull class]])) {
                    error = [NSError errorWithDomain:[NSString stringWithFormat:@"need value for key [%@ %@]",format.fatherKey?:@"",format.keyName] code:-2 userInfo:nil];
                    if (error) {
                        break;
                    }
                }
                error = [self validateJson:value WithValidateObject:format.child];
                if (error) {
                    break;
                }
            }else
            {
                error = [self validateJson:value WithValidateObject:format];
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

@end
