//
//  NSObject+LXJsonModel.h
//  LXRouter
//
//  Created by 58 on 2018/4/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LXJsonModel)

+ (nullable instancetype)lx_modelWithJSON:(id)json;

- (nullable id)lx_modelToJSONObject;

+ (BOOL)isClassFromFoundation:(Class)c;

@end
