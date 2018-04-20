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

#define part1End @"/**************begin*****************/"
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
+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass RouteOutPutClass:(NSDictionary *)routeOutPutClass
{
    NSEnumerator *  enumerator = [routeInputClass keyEnumerator];
    NSString * identify;
    NSString * filePath = @"/Users/a58/Desktop/LXRouter/LXRouter/sjt_appBridge.js";
    NSString * readPath = [[NSBundle mainBundle]pathForResource:@"sjt_app" ofType:@"js"];
    NSFileHandle * fileHandel = [NSFileHandle fileHandleForWritingAtPath:filePath];
    NSFileHandle * readHandel = [NSFileHandle fileHandleForReadingAtPath:readPath];
    NSData * baseJsData =[readHandel readDataToEndOfFile];
    NSString * baseJsStr = [[NSString alloc]initWithData:baseJsData encoding:NSUTF8StringEncoding];
    NSRange  range = [baseJsStr rangeOfString:part1End];
    NSString * baseJsPart1 = [baseJsStr substringToIndex:range.location + range.length];
    NSString * baseJsPart2 = [baseJsStr substringFromIndex:range.location + range.length];
    [readHandel closeFile];
    NSMutableString * allJs = [NSMutableString string];
    [allJs appendString:baseJsPart1];
 
    while ((identify = [enumerator nextObject]) !=nil) {
        
        //注释字符串
        NSMutableString * inputCommentsStr = [NSMutableString string];
        NSMutableString * outputCommentsStr = [NSMutableString string];
        //函数入参字符串
        NSMutableString * funcParamsStr = [NSMutableString string];
        //内部函数入参解析字符串
        NSMutableString * paramsAnalyzeStr = [NSMutableString string];
        //函数体
        NSMutableString * funcBody = [NSMutableString string];
        
        //通过输入函数设置
        Class inputClz = routeInputClass[identify];
        if (inputClz) {
            NSDictionary * dic = [LXJsonValidateTools genValidateObjectWithClass:inputClz];
           // NSLog(@"%@",dic.lx_modelToJSONObject);

            //函数说明
            NSString * funcComments = [LXJsonValidateTools genFuncCommentsWithClass:inputClz];
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            
                //  /**
                [inputCommentsStr appendFormat:@"%@/**\n",tab];
                if (funcComments) {
                    [inputCommentsStr appendFormat:@"%@%@ %@\n",tab,star,funcComments];
                }
                //最外层key值大于4个
                BOOL params2More = dic.allKeys.count > 4;
                if (params2More) {
                    //*@param {Object    }  inputParams
                    [inputCommentsStr appendFormat:@"%@%@ @param {%@}  %@",tab,star,Object,funcParamsKey];
                    [inputCommentsStr appendString:@"\n"];
                    //*inputParams = {
                    [inputCommentsStr appendFormat:@"%@%@ %@ = { \n",tab,star,funcParamsKey];
                    //函数参数增加 inputParams
                    [funcParamsStr appendFormat:@"%@",funcParamsKey];
                }
                
                [LXRouterTools setStrRecursiveWithValidateObject:dic params2More:params2More commentsStr:inputCommentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                
                //参数解析
                if (paramsAnalyzeStr.length) {
                    // var params = {
                    NSString * varBegin =    [NSString stringWithFormat:@"\n%@%@var %@= %@\n",tab,tab,innerParams,lBrace];
                    paramsAnalyzeStr = [NSMutableString stringWithFormat:@"%@%@%@%@%@\n\n",varBegin,paramsAnalyzeStr,tab,tab,rBrace];
                }
                
                if (params2More) {
                    [inputCommentsStr appendFormat:@"%@%@ }\n",tab,star];
                }
                [inputCommentsStr appendFormat:@"%@%@ @param %-10s callBack -回调函数\n",tab,star,@"{func}".UTF8String];
                
                if (funcParamsStr.length) {
                    [funcParamsStr appendString:@","];
                }
                [funcParamsStr appendString:callBack];
                funcParamsStr = [NSMutableString stringWithFormat:@"%@%@:function (%@)",tab,identify,funcParamsStr];
                

                [funcBody appendFormat:@"  {\n"];
                [funcBody appendString:paramsAnalyzeStr];
                [funcBody appendFormat:@"%@%@this._callNative(\"%@\",params,callBack);\n",tab,tab,identify];
                [funcBody appendFormat:@"%@}",tab];

            }
        }
        
        [outputCommentsStr appendFormat:@"%@* \n",tab];
        [outputCommentsStr appendFormat:@"%@* ###输出信息如下###:\n",tab];
        [outputCommentsStr appendFormat:@"%@* responseObj = {\n",tab];
        
        Class outputClz = routeOutPutClass[identify];
        if (outputClz) {
            NSDictionary * dic = [LXJsonValidateTools genValidateObjectWithClass:outputClz];
            
            if (dic && [dic isKindOfClass:[NSDictionary class]])
            {
                [LXRouterTools setStrRecursiveWithValidateObject:dic outPutCommentsStr:outputCommentsStr];
                
            }
        }
        [outputCommentsStr appendFormat:@"%@* }\n",tab];
        [outputCommentsStr appendFormat:@"%@* error = {\n",tab];
        [outputCommentsStr appendFormat:@"%@* errorCode: //String\n",tab];
        [outputCommentsStr appendFormat:@"%@* errorMsg: //String\n",tab];
        [outputCommentsStr appendFormat:@"%@* }\n",tab];
        [outputCommentsStr appendFormat:@"%@*/",tab];
        
        NSString * functionStr = [NSString stringWithFormat:@" \n%@%@ \n \n%@%@  ,",inputCommentsStr,outputCommentsStr,funcParamsStr,funcBody ];
        [allJs appendString:functionStr];
        
    }
    [allJs appendString:baseJsPart2];
    
    [fileHandel writeData:[allJs dataUsingEncoding:NSUTF8StringEncoding]];
}

+(BOOL)setStrRecursiveWithValidateObject:(id)json outPutCommentsStr:(NSMutableString *)outPutCommentsStr
{
    
    if([json isKindOfClass:[NSDictionary class]])//自定义对象
    {
        NSString * itemKey;
        NSEnumerator * dicEnumerator =[json keyEnumerator];
        while ((itemKey = [dicEnumerator nextObject] )!= nil) {
            id value = json[itemKey];
            [self setStrRecursiveWithValidateObject:value outPutCommentsStr:outPutCommentsStr];
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
                    [self setStrRecursiveWithValidateObject:value outPutCommentsStr:outPutCommentsStr];
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
            NSString * blockJSType;
            if (![LXJsonValidateTools isClassFromFoundation:NSClassFromString(annotation.typeName)]) {
                jsType = @"Object";
            }else
            {
                jsType = dic[annotation.typeName];
                if (!jsType) {
                    jsType = @"Undefine";
                }
            }
            blockJSType = [NSString stringWithFormat:@"{%@}",jsType];
            
            NSInteger level = annotation.level;
            NSMutableString * mtab = [NSMutableString string];
            while (level) {
                [mtab appendString:tab];
                level --;
            }
            // *    isTest:  //NSNumber -是否测试
            [outPutCommentsStr appendFormat:@"%@%@%@%@:  //%@ -%@ \n",tab,star,mtab,annotation.keyName,jsType,annotation.comments?:@""];
            //如果当前节点有子节点
            if (annotation.child) {
                
                //opts = [{
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [outPutCommentsStr appendFormat:@"%@%@%@%@ = %@%@\n",tab,star,tab,annotation.keyName,lSquareBracket,lBrace];
                }else//opts = {
                {
                    [outPutCommentsStr appendFormat:@"%@%@%@%@ = %@\n",tab,star,tab,annotation.keyName,lBrace];
                }
                
                [self setStrRecursiveWithValidateObject:annotation.child outPutCommentsStr:outPutCommentsStr];
                //结尾 }]
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [outPutCommentsStr appendFormat:@"%@%@%@%@%@\n",tab,star,tab,rBrace,rSquareBracket];
                }else //结尾 }
                {
                    [outPutCommentsStr appendFormat:@"%@%@%@%@\n",tab,star,tab,rBrace];
                }
                
            }
            
        }
        return YES;
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
            NSString * blockJSType;
            if (![LXJsonValidateTools isClassFromFoundation:NSClassFromString(annotation.typeName)]) {
                jsType = @"Object";
            }else
            {
                jsType = dic[annotation.typeName];
                if (!jsType) {
                   jsType = @"Undefine";
                }
            }
            blockJSType = [NSString stringWithFormat:@"{%@}",jsType];
            //第一级
            if (annotation.level == 1) {
                //参数过多，只传一个model，不需要拼写参数了
                if (!params2More) {
                    
                    if (funcParamsStr.length) {
                        [funcParamsStr appendFormat:@",%@",annotation.keyName];
                    }else //第一个参数不需要 ,
                    {
                        [funcParamsStr appendFormat:@"%@",annotation.keyName];
                    }
                    

                    [commentsStr appendFormat:@"%@%@ @param %-10s %@ \n",tab,star,blockJSType.UTF8String,annotation.keyName];
                    
                    //isTest: isTest
                    [paramsAnalyzeStr appendFormat:@"%@%@%@%@:  %@,\n",tab,tab,tab,annotation.keyName,annotation.keyName];
                    
                }else//如果最外层是个对象
                {
                    
                    // *    isTest:  //NSNumber -是否测试
                    [commentsStr appendFormat:@"%@%@%@%@:  //%@ -%@ \n",tab,star,tab,annotation.keyName, jsType,annotation.comments?:@""];
                    
                    //isTest: isTest
                    [paramsAnalyzeStr appendString:[NSString stringWithFormat:@"%@%@%@%@: %@.%@,\n",tab,tab,tab,annotation.keyName,funcParamsKey,annotation.keyName]];
                    
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
                [commentsStr appendFormat:@"%@%@%@%@:  //%@ -%@ \n",tab,star,mtab,annotation.keyName,jsType,annotation.comments?:@""];
            }
            //如果当前节点有子节点
            if (annotation.child) {
                
                //opts = [{
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [commentsStr appendFormat:@"%@%@%@%@ = %@%@\n",tab,star,tab,annotation.keyName,lSquareBracket,lBrace];
                }else//opts = {
                {
                    [commentsStr appendFormat:@"%@%@%@%@ = %@\n",tab,star,tab,annotation.keyName,lBrace];
                }

                [self setStrRecursiveWithValidateObject:annotation.child params2More:params2More commentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                //结尾 }]
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [commentsStr appendFormat:@"%@%@%@%@%@\n",tab,star,tab,rBrace,rSquareBracket];
                }else //结尾 }
                {
                    [commentsStr appendFormat:@"%@%@%@%@\n",tab,star,tab,rBrace];
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
