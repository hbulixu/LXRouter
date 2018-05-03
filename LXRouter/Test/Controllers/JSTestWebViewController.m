//
//  JSTestWebViewController.m
//  LXRouter
//
//  Created by 58 on 2018/4/25.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "JSTestWebViewController.h"
#import "LXJSBridgeAnalysis.h"
#import <WebKit/WebKit.h>
@interface JSTestWebViewController ()<UIWebViewDelegate,WKNavigationDelegate>
@property (nonatomic,retain)UIWebView * webView;

@property (nonatomic,retain)WKWebView * wkWebView;
@end

@implementation JSTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.view addSubview:self.webView];
    [self.view addSubview:self.wkWebView];
        
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * htmlPath = [NSString stringWithFormat:@"%@/sjt_JSTestRun.html",docDir];
    NSURL *baseURL = [NSURL fileURLWithPath:docDir];
//    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
//                                                    encoding:NSUTF8StringEncoding
//                                                       error:nil];
//    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    // 3.加载文件
    [self.wkWebView loadFileURL:url allowingReadAccessToURL:baseURL];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{

    NSString *urlString = navigationAction.request.URL.absoluteString;
    if ([LXJSBridgeAnalysis debug_wkWebView:webView shouldStartLoadAfterTransUriToRouter:urlString])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    return  [LXJSBridgeAnalysis debug_webView:webView shouldStartLoadAfterTransUriToRouter:urlString];
}

-(UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
    }
    return _webView;
}

-(WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _wkWebView.navigationDelegate = self;
    }
    
    return _wkWebView;
}
@end
