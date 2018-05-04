//
//  pay58TestViewController.m
//  LXRouter
//
//  Created by 58 on 2018/5/4.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "pay58TestViewController.h"
#import "LXJSBridgeAnalysis.h"
@interface pay58TestViewController ()<UIWebViewDelegate>

@property (nonatomic,retain)UIWebView * webView;
@end

@implementation pay58TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"sjt_JSTestRun.html" ofType:nil];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]];
    
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    return  [LXJSBridgeAnalysis webView:webView shouldStartLoadAfterTransUriToRouter:urlString];
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
    }
    return _webView;
}


@end
