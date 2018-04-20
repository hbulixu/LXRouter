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
+ ( id)genValidateObjectWithClass:(Class) clz;
+ ( id)genFuncCommentsWithClass:(Class) clz;
+ (BOOL)isClassFromFoundation:(Class)c;
@end
