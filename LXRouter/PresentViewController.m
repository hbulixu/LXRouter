//
//  PresentViewController.m
//  LXRouter
//
//  Created by 58 on 2018/1/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "PresentViewController.h"
#import "LXRouter.h"
@interface PresentViewController ()

@end

@implementation PresentViewController


+(void)load
{
    [LXRouter registerIdentify:@"test2" toHandler:^(LXRouterInfo *routerInfo) {
        
        PresentViewController * vc = [PresentViewController new];
        [routerInfo.topViewController presentViewController:vc animated:YES completion:nil];
    }];
   
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

@end
