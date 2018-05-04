//
//  Pay58Controller.m
//  LXRouter
//
//  Created by 58 on 2018/5/4.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "Pay58Controller.h"
#import "LXRouter.h"
#import "SJTPayModel.h"
#import "SJTPayResult.h"
@interface Pay58Controller ()
@property (nonatomic,copy)void(^finishBlock)(NSInteger number);
@property (nonatomic,assign)NSInteger number;
@end

@implementation Pay58Controller


+(void)load
{
    [LXRouter registerIdentify:@"pay58" inputClass:[SJTPayModel class] outputClass:[SJTPayResult class] toHandler:^(LXRouterInfo *routerInfo) {
        
        
        
        Pay58Controller * vc = [Pay58Controller pay58FinishBlock:^(NSInteger number) {
            SJTPayResult * result =[SJTPayResult new];
            result.payNumber = [NSString stringWithFormat:@"%ld",number];
            routerInfo.completionBlock(result, nil);
        }];
        
        [routerInfo.topNavigationController pushViewController:vc animated:YES];
        
    }];
}

+(instancetype)pay58FinishBlock:(void(^)(NSInteger number))finishBlock
{
    Pay58Controller * vc = [Pay58Controller new];
    vc.finishBlock = finishBlock;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    _number = rand();
    NSString * title = [NSString stringWithFormat:@"支付:%ld",(long)_number];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 300, 50);
    button.center = self.view.center;
    [self.view addSubview:button];
}

-(void)pay
{
    if (self.finishBlock) {
        self.finishBlock(_number);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
