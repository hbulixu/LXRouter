//
//  TestObj.h
//  LXRouter
//
//  Created by 58 on 2018/4/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"
#import "Test2Obj.h"
@interface TestObj : NSObject

@ParamRequired
@property (nonatomic,weak)NSString * test;

@ParamRequired
@property (nonatomic,retain)NSString * test2;
@PRComments(是否测试)
@ParamRequired
@property (nonatomic,assign)BOOL isTest;
@ParamRequired
@property (nonatomic,retain)Test2Obj * hhh;

@ParamRequired
@DSProtocol(Test2Obj)
@property (nonatomic,retain)NSArray <Test2Obj *>* array;
@ParamRequired
@property (nonatomic,retain)NSArray * urls;

@end
