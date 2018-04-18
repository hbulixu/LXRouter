//
//  Test2Obj.h
//  LXRouter
//
//  Created by 58 on 2018/4/13.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeAnnotation.h"

@interface Test2Obj : NSObject
@property (nonatomic,retain)NSString * aaaa;
@ParamRequired
@property (nonatomic,retain)NSNumber * number;
@property (nonatomic,retain)NSDate * date;
@property (nonatomic,retain)NSData * data;
@end
