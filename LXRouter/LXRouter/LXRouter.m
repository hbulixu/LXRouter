//
//  LXRouter.m
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouter.h"
#import "LXRouterTools.h"
#import "NSObject+LXJsonModel.h"
static NSString * errorDomain = @"lx.router.error";
@interface LXRouter()



@end

@implementation LXRouter

+ (instancetype)sharedInstance
{
    static LXRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL]init];
    });
    return instance;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    return [LXRouter sharedInstance];
}

+(void)registerIdentify:(NSString *)identify inputClass:(Class) clz toHandler:(LXRouterHandler) handler
{
    LXRouter * router =  [LXRouter sharedInstance];
    if (identify && handler) {
        
        @synchronized (router) {
            if (handler) {
                [router.routeHandle setObject:[handler copy] forKey:identify];
            }
            if (clz) {
                [router.routeInputClass setObject:clz forKey:identify];
            }
        }
    }
}

//注册一个路由
+(void)registerIdentify:(NSString *)identify inputJson:(id) json toHandler:(LXRouterHandler)handler
{
    LXRouter * router =  [LXRouter sharedInstance];
    
    if (identify && handler) {
        
        @synchronized (router) {
            if (handler) {
                [router.routeHandle setObject:[handler copy] forKey:identify];
            }
            if (json) {
                [router.routeJson setObject:json forKey:identify];
            }
        }
    }

}

//执行一个路由
+(void)openIdentify:(NSString *)identify withJson:(id)json completion:(void (^)(id result,NSError *error))completion
{
    
    LXRouterInfo * routerInfo = [LXRouterInfo new];
    routerInfo.jsonInfo = json;
    routerInfo.completionBlock = completion;
    NSError *error = nil;
    
    LXRouterHandler handler = [[LXRouter sharedInstance].routeHandle objectForKey:identify];
    
//    id formJson = [[LXRouter sharedInstance].routeJson objectForKey:identify];
    
//    if (formJson) {
//        if (![LXRouter validateJSON:json withValidator:formJson]) {
//            error = [NSError errorWithDomain:errorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"invalidate json"}];
//            completion(nil,error);
//            return;
//        };
//    }
    Class clz = [[LXRouter sharedInstance].routeInputClass objectForKey:identify];
    if (clz) {
        NSError * error = [LXRouterTools validateJson:json WithClass:clz];
        if (error) {
            completion(nil,error);
            return;
        }
        routerInfo.inputModel = [clz lx_modelWithJSON:json];
    }
    if (handler) {
        handler(routerInfo);
    }else
    {
        error = [NSError errorWithDomain:errorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey:@"not find handle"}];
        completion(nil,error);
    }
}



#pragma mark -GET&SET

-(NSMutableDictionary *)routeJson
{
    if (!_routeJson) {
        _routeJson = [[NSMutableDictionary alloc]init];
    }
    return _routeJson;
}

- (NSMutableDictionary *)routeHandle
{
    if (!_routeHandle) {
        _routeHandle = [[NSMutableDictionary alloc] init];
    }
    return _routeHandle;
}

-(NSMutableDictionary *)routeInputClass
{
    if (!_routeInputClass) {
        _routeInputClass = [NSMutableDictionary dictionary];
    }
    return _routeInputClass;
}
@end
