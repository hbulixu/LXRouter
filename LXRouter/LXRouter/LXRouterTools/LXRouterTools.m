//
//  LXRouterTools.m
//  LXRouter
//
//  Created by 58 on 2018/4/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouterTools.h"
#import "LXJSCodeGenerator.h"
#import "LXRouterInputValidate.h"
@implementation LXRouterTools


+ (NSError *)validateJson:(id)json WithClass:(Class)clz
{
    return  [LXRouterInputValidate validateJson:json WithClass:clz];
}

+(void)genJavaScriptBridge
{
    [LXJSCodeGenerator genJavaScriptBridge];
}
@end
