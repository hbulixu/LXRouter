//
//  NSObject+LXJsonModel.m
//  LXRouter
//
//  Created by 58 on 2018/4/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "NSObject+LXJsonModel.h"
#import "YYModel.h"
#import "TypeAnnotation.h"

@implementation NSObject (LXJsonModel)

+ (nullable instancetype)lx_modelWithJSON:(id)json
{
    return [self yy_modelWithJSON:json];
}

- (nullable id)lx_modelToJSONObject
{
    return self.yy_modelToJSONObject;
}







@end
