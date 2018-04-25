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
#import "SJTPayModel.h"
#import "NSObject+LXJsonModel.h"
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
    
    [LXRouter registerIdentify:@"dianyixia" inputClass:nil outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        NSError * error = [NSError errorWithDomain:@"1111" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"我是失败代码"}];
        routerInfo.completionBlock(@"aaaaa111", nil);
    }];
    
    [LXRouter registerIdentify:@"callNativePay" inputClass:[SJTPayModel class] outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        //process业务处理
        
        //处理完成后的回调
        routerInfo.completionBlock(nil, nil);
    }];
    [LXRouter registerIdentify:@"nativePay1" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay2" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay3" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay4" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay5" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay6" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay7" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay8" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay9" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay10" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay11" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay12" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay13" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay14" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay15" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay16" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay17" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay18" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay19" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
    [LXRouter registerIdentify:@"nativePay20" inputClass:[SJTPayModel class] outputClass:[SJTPayModel class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

@end
