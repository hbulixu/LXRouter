//
//  LXRouterTools.m
//  LXRouter
//
//  Created by 58 on 2018/4/9.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXRouterTools.h"
#import "LXJsonValidateTools.h"
#import "TypeAnnotation.h"

#define funcParamsKey @"inputParams"
#define innerParams @"params"
#define callBack @"callBack"
#define star @"*"
@implementation LXRouterTools
+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass
{
    NSEnumerator *  enumerator = [routeInputClass keyEnumerator];
    NSString * identify;
    while ((identify = [enumerator nextObject]) !=nil) {
        
        Class clz = routeInputClass[identify];
        if (clz) {
            NSDictionary * dic = [LXJsonValidateTools genValidateObjectWithClass:clz];
            //注释字符串
            NSMutableString * commentsStr = [NSMutableString string];
            //函数入参字符串
            NSMutableString * funcParamsStr = [NSMutableString string];
            //内部函数入参解析字符串
            NSMutableString * paramsAnalyzeStr = [NSMutableString string];
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            
                //最外层key值大于4个
                BOOL params2More = dic.allKeys.count > 4;
                if (params2More) {
                    [commentsStr appendString:[NSString stringWithFormat:@"%@ %@",star,funcParamsKey]];
                    [commentsStr appendString:@"\n"];
                    [funcParamsStr appendString:[NSString stringWithFormat:@"%@,%@",funcParamsKey,callBack]];
                    [paramsAnalyzeStr appendString:[NSString stringWithFormat:@"var %@=%@",innerParams,funcParamsKey]];
                }
                
                [LXRouterTools setStrRecursiveWithValidateObject:dic params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr jsonKey:nil];

            }
        }
    }
}

+(BOOL)setStrRecursiveWithValidateObject:(id )json params2More:(BOOL)params2More commentsStr:(NSMutableString *)commentsStr funcParamsStr:(NSMutableString *)funcParamsStr paramsAnalyzeStr:(NSMutableString *)paramsAnalyzeStr jsonKey:(id)jsonKey
{

    if([json isKindOfClass:[NSDictionary class]])//自定义对象
    {
        NSString * itemKey;
        NSEnumerator * dicEnumerator =[json keyEnumerator];
        while ((itemKey = [dicEnumerator nextObject] )!= nil) {
            id value = json[itemKey];
           [self setStrRecursiveWithValidateObject:value params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr jsonKey:itemKey];
        }
        return YES;
    }else if([json isKindOfClass:[NSArray class]] &&  jsonKey)//数组中存在自定义对象的情况
    {
        NSArray * array = (NSArray *)json;
        if (array.count) {
            [commentsStr appendString:[NSString stringWithFormat:@"%@ %@ {array}",star,jsonKey]];
            [commentsStr appendString:[NSString stringWithFormat:@"%@ ----%@-----begin",star,jsonKey]];
            id model = [array firstObject];
            
            if ([model isKindOfClass:[NSDictionary class]]) {
                
                NSString * itemKey;
                NSEnumerator * dicEnumerator =[json keyEnumerator];
                while ((itemKey = [dicEnumerator nextObject] )!= nil) {
                    id value = json[itemKey];
                    [self setStrRecursiveWithValidateObject:value params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr jsonKey:jsonKey];
                }
            }

            [commentsStr appendString:[NSString stringWithFormat:@"%@ ----%@-----end",star,jsonKey]];
            //
            [funcParamsStr appendString:[NSString stringWithFormat:@",%@",jsonKey]];
        }
        return YES;
    }
    else
    {
        //普通类
        if([json isKindOfClass:[TypeAnnotation class]])
        {
            //第一级
            if (!jsonKey) {
                [funcParamsStr appendString:[NSString stringWithFormat:@",%@",jsonKey]];
            }
        }
       // [commentsStr appendString:[NSString stringWithFormat:@"%@"] ];

        return YES;
    }
}

+ (NSError *)validateJson:(id)json WithClass:(Class)clz
{
   return  [LXJsonValidateTools validateJson:json WithClass:clz];
}

+ (NSError *)newValidateJson:(id)json WithClass:(Class)clz
{
    return  [LXJsonValidateTools newValidateJson:json WithClass:clz];
}

//最外层参数超过三个传对象
// 要生成脚本的样式
//标明参数。
/**
 @param {type} key - comments
 */
//function identify(@param ,responseCallback)
//{
//   var params = {
//      key:parmkey
//   }
//  _callNative("identify",params,responseCallback);
//}
@end
