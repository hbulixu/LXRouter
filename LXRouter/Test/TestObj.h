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


@property (nonatomic,retain)NSString * test2;

@ParamRequired
@property (nonatomic,assign)BOOL isTest;

@property (nonatomic,retain)Test2Obj * hhh;


@DSProtocol(Test2Obj)
@property (nonatomic,retain)NSArray <Test2Obj *>* array;

@property (nonatomic,retain)NSArray * urls;

@end
