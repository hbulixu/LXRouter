//
//  LXRouter.h
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXRouterInfo.h"

typedef void (^LXRouterHandler)(LXRouterInfo *routerInfo);

@interface LXRouter : NSObject

//注册一个方法路由
+(void)registerIdentify:(NSString *)identify toHandler:(LXRouterHandler)handler;

//执行一个路由
+ (void)openIdentify:(NSString *)identify withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion;


@end
