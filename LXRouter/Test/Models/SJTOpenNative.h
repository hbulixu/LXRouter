//
//  SJTOpenNative.h
//  LXRouter
//
//  Created by 58 on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

/**
 这样做只是展示解析多层结构的问题，
 真正注册应该是shopDynamic是一个模块，mPublish是一个模块
 */
#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"

@class SJTOpenNativeParams;
@interface SJTOpenNative : NSObject
FCComments(打开本地页面)
PRComments(_1_native跳转2_web跳转)
@property (nonatomic,copy)NSString * jumpType;
@property (nonatomic,retain)SJTOpenNativeParams * params;
PRComments(shopDynamic_商家动态_mPublish_发布页面_postGoods_商品发布_58busiSchool_58商学院_trace_访客足迹_task_每日任务)
@property (nonatomic,copy)NSString * symbol;
PRComments(跳转的url)
@property (nonatomic,copy)NSString * url;
PRComments(埋点信息)
@property (nonatomic,copy)NSString * markPointName;

@end

@interface SJTOpenNativeParams :NSObject
PRComments(埋点信息)
@property (nonatomic,copy)NSString * titleName;
PRComments(是否显示关闭按钮)
@property (nonatomic,assign)BOOL  isShowClose;
PRComments(是否显示nativebar)
@property (nonatomic,assign)BOOL  isShowTitleBar;

@end
