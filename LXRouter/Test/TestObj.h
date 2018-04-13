//
//  TestObj.h
//  LXRouter
//
//  Created by 58 on 2018/4/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"
@interface TestObj : NSObject

@paramRequired
@property (nonatomic,retain)NSString * test;

@paramRequired
@property (nonatomic,retain)NSString * test2;

@paramRequired

@end
