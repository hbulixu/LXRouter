//
//  LXRouterPrivate.h
//  LXRouter
//
//  Created by 58 on 2018/4/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXRouter(read)

@property (nonatomic,retain,readonly) NSMutableDictionary *routeHandle;
@property (nonatomic,retain,readonly) NSMutableDictionary *routeJson;
@property (nonatomic,retain,readonly) NSMutableDictionary *routeInputClass;
@property (nonatomic,retain,readonly) NSMutableDictionary *routeOutputClass;
+ (instancetype)sharedInstance;

@end
