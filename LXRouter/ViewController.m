//
//  ViewController.m
//  LXRouter
//
//  Created by 58 on 2018/1/15.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "ViewController.h"
#import "LXRouter.h"
#import "NSObject+LXJsonModel.h"
#import "LXJsonValidateTools.h"
#import "TestObj.h"
#import "LXRouterTools.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [LXRouterTools genScriptBridgeWithRouteHandles:[LXRouter sharedInstance].routeHandle RouteInputClass:[LXRouter sharedInstance].routeInputClass];
    
//    [LXRouter openIdentify:@"test1" withUserInfo:@{@"title":@"测试"} completion:^(id result) {
//        
//    }];
//        NSDictionary * dic = @{@"hhh" : @{@"aaaa":@"11111",@"number":@"2222"},
//                               @"test2":@"",
//                               @"test" :@"",
//                               @"isTest":@"1",
//                               @"urls":@[@{@"aaaa":@"11111",@"number":@"2222"}],
//                               @"array":@[]
//                               //@"array":@[@{@"aaaa":@"11111",@"number":@"2222"}]
//                               };
//
//    [LXRouter openIdentify:@"test" withJson:dic completion:^(id result,NSError *error) {
//        NSLog(@"%@",error);
//    }];
    

//    NSDictionary * dic = [LXJsonValidateTools newGenValidateObjectWithClass:[TestObj class]];
//    
//    NSLog(@"%@",dic.lx_modelToJSONObject);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [LXRouter openIdentify:@"test1" withUserInfo:@{@"title":@"测试1"} completion:^(id result) {
//
//        }];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//
//        [LXRouter openIdentify:@"test2" withUserInfo:nil completion:^(id result) {
//
//        }];
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [LXRouter openIdentify:@"test1" withUserInfo:@{@"title":@"测试1"} completion:^(id result) {
//
//        }];
//    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
