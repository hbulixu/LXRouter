//
//  LXRouterTools.m
//  LXRouter
//
//  Created by 58 on 2018/4/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouterTools.h"
#import "LXJsonValidateTools.h"
@implementation LXRouterTools
+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteJsons:(NSDictionary *)routeJsons
{
    
}

+ (NSError *)validateJson:(id)json WithClass:(Class)clz
{
   return  [LXJsonValidateTools validateJson:json WithClass:clz];
}
@end
