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
@property (nonatomic,retain)UIWebView * webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    
   // [LXRouterTools genScriptBridgeWithRouteHandles:[LXRouter sharedInstance].routeHandle RouteInputClass:[LXRouter sharedInstance].routeInputClass];
    
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSArray *urlCompnents = [urlString componentsSeparatedByString:@"wbbpchannel://"];
    BOOL needProcess = urlCompnents.count >= 2 ? YES : NO;
    if (!needProcess) {
        return YES;
    }
    
    NSString *component = [urlCompnents lastObject];
    NSString *strAction = [component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *strData = [strAction dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *strDic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:NULL];
    NSString *funcName = [NSString stringWithFormat:@"%@:", strDic[@"function"]];
    NSDictionary *paramDic = strDic[@"params"];
    NSString * callBackId = strDic[@"callbackId"];
    if (callBackId) {
        NSDictionary * callBackJson = @{@"responseId":callBackId};
       NSString  * jsonString = [ViewController dictionaryToJson:callBackJson];
        NSString * callBack =  [NSString stringWithFormat:@"sjtApp._dispatchMessageFromNative('%@')",jsonString];
        [webView stringByEvaluatingJavaScriptFromString:callBack];
    }
    NSLog(@"%@",strDic);
    return NO;
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
    }
    return _webView;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    if (!dic) {
        return @"";
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    
}

@end
