//
//  LXJSBridgeAnalysis.m
//  LXRouter
//
//  Created by 58 on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXJSBridgeAnalysis.h"
#import "LXRouter.h"
#import "NSObject+LXJsonModel.h"
@implementation LXJSBridgeAnalysis

+(BOOL)webView:(UIWebView *)webView shouldStartLoadAfterTransUriToRouter:(NSString *)uri
{
    
    NSString *urlString = uri;
    NSArray *urlCompnents = [urlString componentsSeparatedByString:@"wbbpchannel://"];
    BOOL needProcess = urlCompnents.count >= 2 ? YES : NO;
    if (!needProcess) {
        return YES;
    }
    
    NSString *component = [urlCompnents lastObject];
    NSString *message = [component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:NULL];
    
    if(!messageDic||![messageDic isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
        
    NSString *funcName = [NSString stringWithFormat:@"%@", messageDic[@"function"]];
    NSDictionary *paramDic = messageDic[@"params"];
    NSString * callBackId = messageDic[@"callbackId"];
    
    [LXRouter openIdentify:funcName withJson:paramDic completion:^(id result, NSError *error) {
        
        if (callBackId) {
            NSDictionary * responseData = @{@"responseObj":result?:@"",
                                            @"error":error?@{
                                                @"errorMsg":error.userInfo[NSLocalizedDescriptionKey]?:@"",
                                                @"errorCode":@(error.code)                                                }:[NSNull null]
                                            };
            NSDictionary * callBackResponse = @{@"responseId":callBackId,
                                            @"responseData": responseData
                                            };
            
            NSString * callBack =  [NSString stringWithFormat:@"sjtApp._dispatchMessageFromNative('%@')",callBackResponse.lx_modelToJSONString];
            [webView stringByEvaluatingJavaScriptFromString:callBack];
        }
        
    }];
    return NO;
}



+(BOOL)debug_webView:(UIWebView *)webView shouldStartLoadAfterTransUriToRouter:(NSString *)uri
{
    NSString *urlString = uri;
    NSArray *urlCompnents = [urlString componentsSeparatedByString:@"wbbpchannel://"];
    BOOL needProcess = urlCompnents.count >= 2 ? YES : NO;
    if (!needProcess) {
        return YES;
    }
    
    NSString *component = [urlCompnents lastObject];
    NSString *message = [component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:NULL];
    
    if(!messageDic||![messageDic isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    NSString *funcName = [NSString stringWithFormat:@"%@", messageDic[@"function"]];
    NSDictionary *paramDic = messageDic[@"params"];
    NSString * callBackId = messageDic[@"callbackId"];
    
    [LXRouter debug_openIdentify:funcName withJson:paramDic completion:^(id result, NSError *error) {
        
        if (callBackId) {
            NSDictionary * responseData = @{@"responseObj":((NSObject*)result).lx_modelToJSONObject?:@"",
                                            @"error":error?@{
                                                @"errorMsg":error.userInfo[NSLocalizedDescriptionKey]?:@"",
                                                @"errorCode":@(error.code)                                                }:[NSNull null]
                                            };
            NSDictionary * callBackResponse = @{@"responseId":callBackId,
                                                @"responseData": responseData
                                                };
            
            NSString * callBack =  [NSString stringWithFormat:@"sjtApp._dispatchMessageFromNative('%@')",callBackResponse.lx_modelToJSONString];
            NSLog(@"%@",callBack);
            [webView stringByEvaluatingJavaScriptFromString:callBack];
        }
        
    }];
    return NO;
}


+(BOOL)wkWebView:(WKWebView *)wkWebView shouldStartLoadAfterTransUriToRouter:(NSString *)uri
{
    NSString *urlString = uri;
    NSArray *urlCompnents = [urlString componentsSeparatedByString:@"wbbpchannel://"];
    BOOL needProcess = urlCompnents.count >= 2 ? YES : NO;
    if (!needProcess) {
        return YES;
    }
    
    NSString *component = [urlCompnents lastObject];
    NSString *message = [component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:NULL];
    
    if(!messageDic||![messageDic isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    NSString *funcName = [NSString stringWithFormat:@"%@", messageDic[@"function"]];
    NSDictionary *paramDic = messageDic[@"params"];
    NSString * callBackId = messageDic[@"callbackId"];
    
    [LXRouter openIdentify:funcName withJson:paramDic completion:^(id result, NSError *error) {
        
        if (callBackId) {
            NSDictionary * responseData = @{@"responseObj":((NSObject*)result).lx_modelToJSONObject?:@"",
                                            @"error":error?@{
                                                @"errorMsg":error.userInfo[NSLocalizedDescriptionKey]?:@"",
                                                @"errorCode":@(error.code)                                                }:[NSNull null]
                                            };
            NSDictionary * callBackResponse = @{@"responseId":callBackId,
                                                @"responseData": responseData
                                                };
            
            NSString * callBack =  [NSString stringWithFormat:@"sjtApp._dispatchMessageFromNative('%@')",callBackResponse.lx_modelToJSONString];
            NSLog(@"%@",callBack);
            [wkWebView evaluateJavaScript:callBack completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
            }];
        }
        
    }];
    return NO;
}
+(BOOL)debug_wkWebView:(WKWebView *)wkWebView shouldStartLoadAfterTransUriToRouter:(NSString *)uri
{
    NSString *urlString = uri;
    NSArray *urlCompnents = [urlString componentsSeparatedByString:@"wbbpchannel://"];
    BOOL needProcess = urlCompnents.count >= 2 ? YES : NO;
    if (!needProcess) {
        return YES;
    }
    
    NSString *component = [urlCompnents lastObject];
    NSString *message = [component stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:NULL];
    
    if(!messageDic||![messageDic isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    NSString *funcName = [NSString stringWithFormat:@"%@", messageDic[@"function"]];
    NSDictionary *paramDic = messageDic[@"params"];
    NSString * callBackId = messageDic[@"callbackId"];
    
    [LXRouter debug_openIdentify:funcName withJson:paramDic completion:^(id result, NSError *error) {
        
        if (callBackId) {
            NSDictionary * responseData = @{@"responseObj":((NSObject*)result).lx_modelToJSONObject?:@"",
                                            @"error":error?@{
                                                @"errorMsg":error.userInfo[NSLocalizedDescriptionKey]?:@"",
                                                @"errorCode":@(error.code)                                                }:[NSNull null]
                                            };
            NSDictionary * callBackResponse = @{@"responseId":callBackId,
                                                @"responseData": responseData
                                                };
            
            NSString * callBack =  [NSString stringWithFormat:@"sjtApp._dispatchMessageFromNative('%@')",callBackResponse.lx_modelToJSONString];
            NSLog(@"%@",callBack);
            [wkWebView evaluateJavaScript:callBack completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
            }];
        }
        
    }];
    return NO;
}
@end
