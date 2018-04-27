//
//  SJTNativeImagePicker.h
//  LXRouter
//
//  Created by 58 on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"
@interface SJTNativeImageInput : NSObject
FCComments(调用native支付功能)
PRComments(已上传的图片url)
@property (nonatomic,copy)NSString * imageUrls;
PRComments(最多可以上传多少张最少4张)
@property (nonatomic,assign)NSInteger maxNum;

@end

@interface SJTNativeImageOutput : NSObject
PRComments(已上传的图片url)
@property (nonatomic,copy)NSString * imageUrls;
@end
