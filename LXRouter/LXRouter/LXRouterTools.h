//
//  LXRouterTools.h
//  LXRouter
//
//  Created by 58 on 2018/4/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXRouterTools : NSObject

+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteJsons:(NSDictionary *)routeJsons;

+ (NSError *)validateJson:(id)json WithClass:(Class)clz;
@end
