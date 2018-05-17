//
//  SJTPayModel.h
//  LXRouter
//
//  Created by 58 on 2018/4/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"
extern  NSString  * const kSJT_Common_58Pay;
@interface SJTPayModel : NSObject
FCComments(调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能调用native支付功能)
PRComments(订单金额)
ParamRequired
@property (nonatomic,copy)NSString * orderMoney;
PRComments(支付类型1_58_2什么)
@property (nonatomic,copy)NSString * payType;
PRComments(支付类型1旧接口2新接口)
@property (nonatomic,copy)NSString * balanceType;
PRComments(支付类型1微信2什么)
@property (nonatomic,copy)NSString * payfrom;
@property (nonatomic,copy)NSString * merId;
PRComments(订单id)
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy)NSString * productDesc;
@end
