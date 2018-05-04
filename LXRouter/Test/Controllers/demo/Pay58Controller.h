//
//  Pay58Controller.h
//  LXRouter
//
//  Created by 58 on 2018/5/4.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Pay58Controller : UIViewController



+(instancetype)pay58FinishBlock:(void(^)(NSInteger number))finishBlock;
@end
