//
//  TextViewController.m
//  LXRouter
//
//  Created by 58 on 2018/1/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "TextViewController.h"
#import "LXRouter.h"
#import "LXRouterTools.h"
#import "SJTPayModel.h"
#import "SJTNativeImagePicker.h"
#import "NSObject+LXJsonModel.h"
#import "SJTCountEvent.h"
#import "SJTOpenNative.h"
#import "SJTPostGoods.h"
#import "SJTOpenWebView.h"
@interface TextViewController ()

@end

@implementation TextViewController

+(void)load
{
 
    [LXRouter registerIdentify:@"nativePay" inputClass:[SJTPayModel class] outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",routerInfo.inputModel);
    }];
    
    [LXRouter registerIdentify:@"nativeImagePicker" inputClass:[SJTNativeImageInput class] outputClass:[SJTNativeImageOutput class] toHandler:^(LXRouterInfo *routerInfo) {
        NSLog(@"%@",routerInfo.inputModel);
    }];
    
    [LXRouter registerIdentify:@"backNative" inputClass:nil outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        
    }];
    
    [LXRouter registerIdentify:@"countEvent" inputClass:[SJTCountEvent class] outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        
    }];
    
    [LXRouter registerIdentify:@"openNative" inputClass:[SJTOpenNative class] outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        
    }];
    
    [LXRouter registerIdentify:@"postGoods" inputClass:[SJTPostGoods class] outputClass:[SJTNativeImageOutput class] toHandler:^(LXRouterInfo *routerInfo) {
        
    }];
    
    [LXRouter registerIdentify:@"openWebView" inputClass:[SJTOpenWebView class] outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
        
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
