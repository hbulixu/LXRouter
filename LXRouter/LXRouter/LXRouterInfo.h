//
//  LXRouterInfo.h
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^LXCompletionBlock) ( id data ,NSError *error);

@interface LXRouterInfo : NSObject

//自定义信息
@property (nonatomic,retain)id  jsonInfo;

//回调函数
@property (nonatomic,copy)LXCompletionBlock  completionBlock;

//用于present
@property (nonatomic,retain) UIViewController * topViewController;

//用于push
@property (nonatomic,retain) UINavigationController * topNavigationController;

@end
