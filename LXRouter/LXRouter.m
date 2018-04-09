//
//  LXRouter.m
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouter.h"

static NSString * errorDomain = @"lx.router.error";
@interface LXRouter()

/**
 *  保存了所有已注册的 Identify
 */
@property (nonatomic,retain) NSMutableDictionary *routeHandle;
@property (nonatomic,retain) NSMutableDictionary *routeJson;
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
    
    id formJson = [[LXRouter sharedInstance].routeJson objectForKey:identify];
    
    if (formJson) {
        if (![LXRouter validateJSON:json withValidator:formJson]) {
            error = [NSError errorWithDomain:errorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"invalidate json"}];
            completion(nil,error);
            return;
        };
    }
    if (handler) {
        handler(routerInfo);
    }else
    {
        error = [NSError errorWithDomain:errorDomain code:-2 userInfo:@{NSLocalizedDescriptionKey:@"not find handle"}];
        completion(nil,error);
    }
}

+ (BOOL)validateJSON:(id)json withValidator:(id)jsonValidator {
    if ([json isKindOfClass:[NSDictionary class]] &&
        [jsonValidator isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = json;
        NSDictionary * validator = jsonValidator;
        BOOL result = YES;
        NSEnumerator * enumerator = [validator keyEnumerator];
        NSString * key;
        while ((key = [enumerator nextObject]) != nil) {
            id value = dict[key];
            id format = validator[key];
            if ([value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSArray class]]) {
                result = [self validateJSON:value withValidator:format];
                if (!result) {
                    break;
                }
            } else {
                if ([value isKindOfClass:format] == NO &&
                    [value isKindOfClass:[NSNull class]] == NO) {
                    result = NO;
                    break;
                }
            }
        }
        return result;
    } else if ([json isKindOfClass:[NSArray class]] &&
               [jsonValidator isKindOfClass:[NSArray class]]) {
        NSArray * validatorArray = (NSArray *)jsonValidator;
        if (validatorArray.count > 0) {
            NSArray * array = json;
            NSDictionary * validator = jsonValidator[0];
            for (id item in array) {
                BOOL result = [self validateJSON:item withValidator:validator];
                if (!result) {
                    return NO;
                }
            }
        }
        return YES;
    } else if ([json isKindOfClass:jsonValidator]) {
        return YES;
    } else {
        return NO;
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
@end
