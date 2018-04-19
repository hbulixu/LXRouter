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
#define Object @"Object"
#define tab @"    "
#define lSquareBracket @"["
#define rSquareBracket @"]"
#define lBrace @"{"
#define rBrace @"}"

#
@implementation LXRouterTools

+(NSDictionary *)mapDic
{
    return @{
             @"NSURL":@"String",
             @"NSDate":@"String",
             @"NSString":@"String",
             @"NSArray":@"Array",
             @"NSAttributedString":@"String",
             @"NSDictionary":@"Object",
             @"NSNumber":@"String"
             };
}
+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass
{
    NSEnumerator *  enumerator = [routeInputClass keyEnumerator];
    NSString * identify;
    while ((identify = [enumerator nextObject]) !=nil) {
        
        Class clz = routeInputClass[identify];
        if (clz) {
            NSDictionary * dic = [LXJsonValidateTools genValidateObjectWithClass:clz];
            NSLog(@"%@",dic.lx_modelToJSONObject);
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
                    //*@param {Object    }  inputParams
                    [commentsStr appendFormat:@"%@@param {%-10s}  %@",star,Object.UTF8String,funcParamsKey];
                    [commentsStr appendString:@"\n"];
                    //*inputParams = {
                    [commentsStr appendFormat:@"%@%@ = { \n",star,funcParamsKey];
                    //函数参数增加 inputParams
                    [funcParamsStr appendFormat:@"%@,%@",funcParamsKey,callBack];
                }
                
                [LXRouterTools setStrRecursiveWithValidateObject:dic params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                
                //参数解析
                if (paramsAnalyzeStr.length) {
                    // var params = inputParams
                    NSString * varBegin =    [NSString stringWithFormat:@"var %@=%@ %@\n",innerParams,funcParamsKey,lBrace];
                    paramsAnalyzeStr = [NSMutableString stringWithFormat:@"%@%@\n%@",varBegin,paramsAnalyzeStr,rBrace];
                }
                if (params2More) {
                    [commentsStr appendFormat:@"%@ }",star];
                }
            }
            NSLog(@"commentsStr :\n%@ \n funcParamsStr:\n%@ \n paramsAnalyzeStr:\n%@  ",commentsStr,funcParamsStr,paramsAnalyzeStr);
        }
    }
}

+(BOOL)setStrRecursiveWithValidateObject:(id )json params2More:(BOOL)params2More commentsStr:(NSMutableString *)commentsStr funcParamsStr:(NSMutableString *)funcParamsStr paramsAnalyzeStr:(NSMutableString *)paramsAnalyzeStr
{

    if([json isKindOfClass:[NSDictionary class]])//自定义对象
    {
        NSString * itemKey;
        NSEnumerator * dicEnumerator =[json keyEnumerator];
        while ((itemKey = [dicEnumerator nextObject] )!= nil) {
            id value = json[itemKey];
           [self setStrRecursiveWithValidateObject:value params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr ];
        }
        return YES;
    }else if([json isKindOfClass:[NSArray class]] )//数组中存在自定义对象的情况
    {
        NSArray * array = (NSArray *)json;
        if (array.count) {
            id dic = [array firstObject];
            
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSString * itemKey;
                NSEnumerator * dicEnumerator =[dic keyEnumerator];
                while ((itemKey = [dicEnumerator nextObject] )!= nil) {
                    id value = dic[itemKey];
                    [self setStrRecursiveWithValidateObject:value params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                }
            }
        }
        return YES;
    }
    else
    {
        TypeAnnotation * annotation = json;
        //普通类
        if([annotation isKindOfClass:[TypeAnnotation class]])
        {
            NSDictionary * dic = [self mapDic];
            //自定义类型
            NSString * jsType;
            if (![LXJsonValidateTools isClassFromFoundation:NSClassFromString(annotation.typeName)]) {
                jsType = @"Object";
            }else
            {
                jsType = dic[annotation.typeName];
                if (!jsType) {
                   jsType = @"Undefine";
                }
            }
            //第一级
            if (annotation.level == 1) {
                //参数过多，只传一个model，不需要拼写参数了
                if (!params2More) {
                    [funcParamsStr appendString:[NSString stringWithFormat:@",%@",annotation.keyName]];

                    [commentsStr appendFormat:@"%@@param {%-10s} %@ \n",star,jsType.UTF8String,annotation.keyName];
                    
                    //isTest: isTest
                    [paramsAnalyzeStr appendString:[NSString stringWithFormat:@"%@: %@",annotation.keyName,annotation.keyName]];
                    
                }else//如果最外层是个对象
                {
                    
                    // *    isTest:  //NSNumber -是否测试
                    [commentsStr appendFormat:@"%@%@%@:  //%@ -%@ \n",star,tab,annotation.keyName, jsType,annotation.comments?:@""];
                    
                    //isTest: isTest
                    [paramsAnalyzeStr appendString:[NSString stringWithFormat:@"%@%@: %@,\n",tab,annotation.keyName,annotation.keyName]];
                    
                }
 
            }else //第二级 第三级 ...
            {
                NSInteger level = annotation.level;
                NSMutableString * mtab = [NSMutableString string];
                while (level) {
                    [mtab appendString:tab];
                    level --;
                }
                // *    isTest:  //NSNumber -是否测试
                [commentsStr appendFormat:@"%@%@%@:  //%@ -%@ \n",star,mtab,annotation.keyName,jsType,annotation.comments?:@""];
            }
            //如果当前节点有子节点
            if (annotation.child) {
                
                //opts = [{
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [commentsStr appendFormat:@"%@%@%@ = %@%@\n",star,tab,annotation.keyName,lSquareBracket,lBrace];
                }else//opts = {
                {
                    [commentsStr appendFormat:@"%@%@%@ = %@\n",star,tab,annotation.keyName,lBrace];
                }

                [self setStrRecursiveWithValidateObject:annotation.child params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                //结尾 }]
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [commentsStr appendFormat:@"%@%@%@%@\n",star,tab,rBrace,rSquareBracket];
                }else //结尾 }
                {
                    [commentsStr appendFormat:@"%@%@%@\n",star,tab,rBrace];
                }
                
            }
            
        }
        


        return YES;
    }
}


+ (NSError *)validateJson:(id)json WithClass:(Class)clz
{
    return  [LXJsonValidateTools validateJson:json WithClass:clz];
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
