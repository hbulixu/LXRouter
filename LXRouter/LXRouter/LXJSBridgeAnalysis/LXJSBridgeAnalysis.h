//
//  LXJSBridgeAnalysis.h
//  LXRouter
//
//  Created by 58 on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LXJSBridgeAnalysis : NSObject

+(BOOL)webView:(UIWebView *)webView shouldStartLoadAfterTransUriToRouter:(NSString *)uri;

//自动化测试使用
+(BOOL)debug_webView:(UIWebView *)webView shouldStartLoadAfterTransUriToRouter:(NSString *)uri;

@end
