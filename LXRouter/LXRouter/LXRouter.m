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

/**
 *  保存了所有已注册的 Identify
 */
@property (nonatomic,retain,readwrite) NSMutableDictionary *routeHandle;
@property (nonatomic,retain,readwrite) NSMutableDictionary *routeInputClass;
@property (nonatomic,retain,readwrite) NSMutableDictionary *routeOutputClass;

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

+(void)registerIdentify:(NSString *)identify inputClass:(Class) input outputClass:(Class) output toHandler:(LXRouterHandler) handler;
{
    LXRouter * router =  [LXRouter sharedInstance];
    if (identify && handler) {
        
        @synchronized (router) {
            if (handler) {
                [router.routeHandle setObject:[handler copy] forKey:identify];
            }
            if (input) {
                [router.routeInputClass setObject:input forKey:identify];
            }
            if (output) {
                [router.routeOutputClass setObject:output forKey:identify];
            }
        }
    }
}

//执行一个路由
+(void)openIdentify:(NSString *)identify withJson:(id)json completion:(void (^)(id result,NSError *error))completion
{
    
    LXRouterInfo * routerInfo = [LXRouterInfo new];
    routerInfo.jsonInfo = json;
    //使用json返回也是json
    routerInfo.completionBlock = ^(id data, NSError *error) {
        id json = nil;
        if (data) {
            json = [data lx_modelToJSONObject];
        }
        completion(json,error);
    };
    NSError *error = nil;
    
    LXRouterHandler handler = [[LXRouter sharedInstance].routeHandle objectForKey:identify];
    
    Class clz = [[LXRouter sharedInstance].routeInputClass objectForKey:identify];
    
    if (clz) {
#if  DEBUG
        error = [LXRouterTools validateJson:json WithClass:clz];
        if (error) {
            completion(nil,error);
            return;
        }
#endif
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

//适用于本地调用
+(void)openIdentify:(NSString *)identify withModel:(id)model completion:(void (^)(id result,NSError *error))completion
{
    
    LXRouterInfo * routerInfo = [LXRouterInfo new];
    routerInfo.completionBlock = [completion copy];
    NSError *error = nil;
    
    LXRouterHandler handler = [[LXRouter sharedInstance].routeHandle objectForKey:identify];
    
    Class clz = [[LXRouter sharedInstance].routeInputClass objectForKey:identify];
    
    
    if (clz) {
        
        if (![model isKindOfClass:clz]) {
            
            error = [NSError errorWithDomain:errorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey:@"inputModel wrong classType"}];
            if (error) {
                completion(nil,error);
                return;
            }
        }
        routerInfo.inputModel = model;
    }
    
    if (handler) {
        handler(routerInfo);
    }else
    {
        error = [NSError errorWithDomain:errorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey:@"not find handle"}];
        completion(nil,error);
    }
}

//为自动测试化准备
+(void)debug_openIdentify:(NSString *)identify withJson:(id)json completion:(void (^)(id result,NSError *error))completion
{
    
    LXRouterInfo * routerInfo = [LXRouterInfo new];
    routerInfo.jsonInfo = json;
    routerInfo.completionBlock = [completion copy];
    NSError *error = nil;
    
    LXRouterHandler handler = [[LXRouter sharedInstance].routeHandle objectForKey:identify];
    
    Class clz = [[LXRouter sharedInstance].routeInputClass objectForKey:identify];
    if (clz) {
        error = [LXRouterTools validateJson:json WithClass:clz];
        if (error) {
            completion(nil,error);
            return;
        }
    }
    
    if (handler) {
        completion(nil,nil);
    }
}


#pragma mark -GET&SET

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

-(NSMutableDictionary *)routeOutputClass
{
    if (!_routeOutputClass) {
        _routeOutputClass = [NSMutableDictionary dictionary];
    }
    return _routeOutputClass;
}
@end
