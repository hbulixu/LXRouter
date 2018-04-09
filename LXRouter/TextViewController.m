//
//  TextViewController.m
//  LXRouter
//
//  Created by 58 on 2018/1/16.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "TextViewController.h"
#import "LXRouter.h"
@interface TextViewController ()

@end

@implementation TextViewController

+(void)load
{
 
    [LXRouter registerIdentify:@"test1" inputJson:@{@"title":[NSString class]} toHandler:^(LXRouterInfo *routerInfo) {
        
        TextViewController * vc = [TextViewController new];
        vc.title = [routerInfo.jsonInfo objectForKey:@"title"];
        [routerInfo.topNavigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc
{
    
}

@end
