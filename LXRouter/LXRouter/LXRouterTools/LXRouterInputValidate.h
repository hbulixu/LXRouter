//
//  LXRouterInputValidate.h
//  LXRouter
//
//  Created by 58 on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXRouterInputValidate : NSObject

+ (NSError *)validateJson:(id)json WithClass:(Class)clz;

@end
