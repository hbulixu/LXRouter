//
//  JSTestWebViewController.m
//  LXRouter
//
//  Created by 58 on 2018/4/25.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "JSTestWebViewController.h"
#import "LXJSBridgeAnalysis.h"

@interface JSTestWebViewController ()<UIWebViewDelegate>
@property (nonatomic,retain)UIWebView * webView;
@end

@implementation JSTestWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    
        
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * htmlPath = [NSString stringWithFormat:@"%@/sjt_JSTestRun.html",docDir];
    NSURL *baseURL = [NSURL fileURLWithPath:docDir];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
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
@end
