//
//  LXJsonValidateTools.h
//  LXRouter
//
//  Created by 58 on 2018/4/17.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXJsonValidateTools : NSObject

+ (NSError *)validateJson:(id)json WithClass:(Class)clz;
+ (nullable id)genValidateObjectWithClass:(Class) clz;

+ (NSError *)newValidateJson:(id)json WithClass:(Class)clz;
+ (nullable id)newGenValidateObjectWithClass:(Class) clz;
@end
