//
//  SJTOpenWebView.h
//  LXRouter
//
//  Created by 58 on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"

@interface SJTOpenWebView : NSObject
FCComments(跳转web页面)
PRComments(跳转的url)
@property (nonatomic,copy)NSString * url;
PRComments(埋点信息)
@property (nonatomic,copy)NSString * titleName;
PRComments(是否显示关闭按钮)
@property (nonatomic,assign)BOOL  isShowClose;
PRComments(是否显示nativebar)
@property (nonatomic,assign)BOOL  isShowTitleBar;
@end
