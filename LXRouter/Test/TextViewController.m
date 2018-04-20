//
//  TextViewController.m
//  LXRouter
//
//  Created by 58 on 2018/1/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "TextViewController.h"
#import "LXRouter.h"
#import "TestObj.h"
#import "LXRouterTools.h"
#import "LXJsonValidateTools.h"
#import "SJTPayModel.h"
@interface TextViewController ()

@end

@implementation TextViewController

+(void)load
{
 
//    [LXRouter registerIdentify:@"test" inputJson:@{@"title":[NSString class]} toHandler:^(LXRouterInfo *routerInfo) {
//
//        TextViewController * vc = [TextViewController new];
//        vc.title = [routerInfo.jsonInfo objectForKey:@"title"];
//        [routerInfo.topNavigationController pushViewController:vc animated:YES];
//    }];
    
    [LXRouter registerIdentify:@"test2" inputClass:[Test2Obj class] outputClass:[TestObj class]  toHandler:^(LXRouterInfo *routerInfo) {
        
    }];
    [LXRouter registerIdentify:@"test" inputClass:[TestObj class]  outputClass:[Test2Obj class]  toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    TestObj * obj1 = [TestObj new];
//    obj1.test = @"111";
//    id  dic1 = [obj1 yy_modelDescription];
//   
//    NSLog(@"%@", obj1.yy_modelToJSONObject);

//    NSDictionary * dic = @{@"test":@1234,
//                           @"test2":@"",
//                           @"isTest": @"12345",
//                           @"hhh" : @{@"aaaa":@"11111",@"number":@"2222"}
////                           };
//    NSDictionary * dic = @{@"hhh" : @{@"aaaa":@"11111",@"number":@"2222"},
//                           @"test":@"1234",
//                           @"test2":@"",
//                           @"isTest":@"1",
//                           @"urls":@[@{@"aaaa":@"11111",@"number":@"2222"}],
//                           @"array":@[@{@"aaaa":@"11111",@"number":@"2222"}]
//                           };
//    
//   TestObj * obj = [TestObj lx_modelWithJSON:dic];
//   // NSLog(@"%@",obj.lx_modelToJSONObject);
//   NSError * error = [LXRouterTools validateJson:obj.lx_modelToJSONObject WithClass:[TestObj class]];
//   // NSLog(@"%@",error);
    
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

@end
