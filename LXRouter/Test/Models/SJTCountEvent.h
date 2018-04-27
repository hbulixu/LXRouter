//
//  SJTCountEvent.h
//  LXRouter
//
//  Created by 58 on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"
@interface SJTCountEvent : NSObject
FCComments(调用app埋点功能)
PRComments(埋点信息)
ParamRequired
@property (nonatomic,copy)NSString * countName;

@end
