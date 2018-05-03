//
//  SJTPostGoods.h
//  LXRouter
//
//  Created by 58 on 2018/4/27.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"
#import "SJTOpenNative.h"
@class SJTImageProperty;
@interface SJTPostGoods : NSObject
FCComments(发布商品)
PRComments(埋点信息)
@property (nonatomic,copy)NSString * markPointName;

PRComments(要发布的信息)
@property (nonatomic,copy)NSString * message;

DSProtocol(SJTImageProperty)
@property (nonatomic,retain)NSArray * imageProperty;

@end

@interface SJTImageProperty : NSObject

PRComments(图片url)
@property (nonatomic,copy)NSString * imageUrl;
PRComments(图片宽度)
@property (nonatomic,assign)float width;
PRComments(图片高度)
@property (nonatomic,assign)float height;
@property (nonatomic,retain) SJTOpenNative * openNative;
@end
