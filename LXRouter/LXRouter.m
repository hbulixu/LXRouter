//
//  LXRouter.m
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouter.h"

@interface LXRouter()

/**
 *  保存了所有已注册的 Identify
 */
@property (nonatomic) NSMutableDictionary *routes;
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


//注册一个路由
+(void)registerIdentify:(NSString *)identify toHandler:(LXRouterHandler)handler
{
    LXRouter * router =  [LXRouter sharedInstance];
    
    if (identify && handler) {
        
        @synchronized (router) {
            
            [router.routes setObject:[handler copy] forKey:identify];
        }
        
    }

}

//执行一个路由
+(void)openIdentify:(NSString *)identify withUserInfo:(NSDictionary *)userInfo completion:(void (^)(id result))completion
{
    
    LXRouterInfo * routerInfo = [LXRouterInfo new];
    routerInfo.info = userInfo;
    routerInfo.completionBlock = completion;
    
    LXRouterHandler handler = [[LXRouter sharedInstance].routes objectForKey:identify];
    if (handler) {
        
        handler(routerInfo);
    }
}


#pragma mark -GET&SET
- (NSMutableDictionary *)routes
{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}
@end
