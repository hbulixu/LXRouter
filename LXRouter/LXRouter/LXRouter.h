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
//调用时会对参数校验
+(void)registerIdentify:(NSString *)identify inputJson:(id) json toHandler:(LXRouterHandler)handler;

+(void)registerIdentify:(NSString *)identify inputClass:(Class) clz toHandler:(LXRouterHandler) handler;
//执行一个路由
+(void)openIdentify:(NSString *)identify withJson:(id)json completion:(void (^)(id result,NSError *error))completion;


+ (instancetype)sharedInstance;
/**
 *  保存了所有已注册的 Identify
 */
@property (nonatomic,retain) NSMutableDictionary *routeHandle;
@property (nonatomic,retain) NSMutableDictionary *routeJson;
@property (nonatomic,retain) NSMutableDictionary *routeInputClass;

@end
