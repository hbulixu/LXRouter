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

//注册一个方法路由,inputParams 是路由的所有参数

+(void)registerIdentify:(NSString *)identify inputClass:(Class) input outputClass:(Class) output toHandler:(LXRouterHandler) handler;
//执行一个路由
+(void)openIdentify:(NSString *)identify withJson:(id)json completion:(void (^)(id result,NSError *error))completion;

+(void)openIdentify:(NSString *)identify withModel:(id)model completion:(void (^)(id result,NSError *error))completion;

@end
