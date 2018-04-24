//
//  NSObject+LXJsonModel.m
//  LXRouter
//
//  Created by 58 on 2018/4/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSObject+LXJsonModel.h"
#import "YYModel.h"
#import "TypeAnnotation.h"
static NSSet *foundationClasses_;
@implementation NSObject (LXJsonModel)

+ (nullable instancetype)lx_modelWithJSON:(id)json
{
    return [self yy_modelWithJSON:json];
}

- (nullable id)lx_modelToJSONObject
{
    return self.yy_modelToJSONObject;
}

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

@end
