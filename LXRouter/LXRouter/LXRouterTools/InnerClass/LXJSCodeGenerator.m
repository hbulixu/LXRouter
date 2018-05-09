//
//  LXJSCodeGenerator.m
//  LXRouter
//
//  Created by 58 on 2018/4/24.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "LXJSCodeGenerator.h"
#import "TypeAnnotation.h"
#import "LXRouter.h"
#import "LXRouterPrivate.h"
#import "LXParamsInfoTree.h"
#import "NSObject+LXJsonModel.h"
#import "AFNetworking.h"

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

@implementation LXJSCodeGenerator

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

+(void)genJavaScriptBridge
{
    [LXJSCodeGenerator genScriptBridgeWithRouteHandles:[LXRouter sharedInstance].routeHandle RouteInputClass:[LXRouter sharedInstance].routeInputClass RouteOutPutClass:[LXRouter sharedInstance].routeOutputClass];
}


/*该方法用于生成代码总体思路如下
 js代码分为两部分，一部分是固定的代码，在sjt_app.js,一部分是通过分析类生成的代码
 **/
+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass RouteOutPutClass:(NSDictionary *)routeOutPutClass
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@",docDir);
    NSString * filePath = [NSString stringWithFormat:@"%@/sjt_appBridge.js",docDir];
    NSString * releaseFilePath =[NSString stringWithFormat:@"%@/sjt_appBridge_release.js",docDir];
    NSString * readPath = [[NSBundle mainBundle]pathForResource:@"sjt_app" ofType:@"js"];
    
    //用于对函数的注释
    NSString * funcCommentsPath = [[NSBundle mainBundle] pathForResource:@"RouterFuncComments" ofType:@"plist"];
    NSDictionary * commentsDic = [[NSDictionary alloc]initWithContentsOfFile:funcCommentsPath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:filePath error:nil];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    [fileManager removeItemAtPath:releaseFilePath error:nil];
    [fileManager createFileAtPath:releaseFilePath contents:nil attributes:nil];
    
    NSFileHandle * fileHandel = [NSFileHandle fileHandleForWritingAtPath:filePath];
    NSFileHandle * releaseFileHandel = [NSFileHandle fileHandleForWritingAtPath:releaseFilePath];
    //用来取固定js的代码
    NSFileHandle * readHandel = [NSFileHandle fileHandleForReadingAtPath:readPath];
    NSData * baseJsData =[readHandel readDataToEndOfFile];
    NSString * baseJsStr = [[NSString alloc]initWithData:baseJsData encoding:NSUTF8StringEncoding];
    NSRange  range = [baseJsStr rangeOfString:part1End];
    //固定代码分为两部分，
    NSString * baseJsPart1 = [baseJsStr substringToIndex:range.location + range.length];
    NSString * baseJsPart2 = [baseJsStr substringFromIndex:range.location + range.length];
    [readHandel closeFile];
    
    //存储最终的js代码
    NSMutableString * allJs = [NSMutableString string];
    //添加上半部分固定代码
    [allJs appendString:baseJsPart1];
    
    NSEnumerator *  enumerator = [routeHandles keyEnumerator];
    NSString * identify;
    while ((identify = [enumerator nextObject]) !=nil) {
        
        //输入注释字符串
        NSMutableString * inputCommentsStr = [NSMutableString string];
        //输出注释字符串
        NSMutableString * outputCommentsStr = [NSMutableString string];
        
        //函数入参字符串
        NSMutableString * funcParamsStr = [NSMutableString string];
        
        //函数体容器，除了注释部分的内容
        NSMutableString * funcBody = [NSMutableString string];
        //内部函数入参组装
        NSMutableString * paramsAnalyzeStr = [NSMutableString string];
        
        
        //通过输入类生成1.输入注释，2.函数入参，3.入参组装，4.调用部分
        Class inputClz = routeInputClass[identify];
        
        if (inputClz) {
            //根据类生成类的字典校验树，该树是生成注释和组装的基础
            NSDictionary * dic = [LXParamsInfoTree genParamsInfoTreeWithClass:inputClz];
            //获取当前函数功能说明
            NSString * funcComments = [LXParamsInfoTree genFuncCommentsWithClass:inputClz];
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                
                //注释头添加开始
                //  /**
                [inputCommentsStr appendFormat:@"%@/**\n",tab];
                
                //如果有函数说明，添加函数说明
                if (funcComments) {
                    [inputCommentsStr appendFormat:@"%@%@ %@\n",tab,star,funcComments];
                }
                
                /*js 函数定义为最多可传入5个参数，包含回调callBack，如果超过4个入参，就用对象（inputParams）包裹所有的入参**/
                BOOL params2More = dic.allKeys.count > 4;
                
                //如果参数被（inputParams）包裹，需要对注释，函数入参特殊处理
                if (params2More) {
                    /*以下生成
                     * @param {Object}  inputParams
                     * inputParams = { *
                     */
                    //*@param {Object    }  inputParams
                    [inputCommentsStr appendFormat:@"%@%@ @param {%@}  %@",tab,star,Object,funcParamsKey];
                    [inputCommentsStr appendString:@"\n"];
                    //*inputParams = {
                    [inputCommentsStr appendFormat:@"%@%@ %@ = { \n",tab,star,funcParamsKey];
                    
                    
                    //函数参数增加 inputParams
                    [funcParamsStr appendFormat:@"%@",funcParamsKey];
                }
                
                //递归处理子节点,组装输入注释，函数入参，入参组装等
                [LXJSCodeGenerator setStrRecursiveWithParamsInfoTree:dic params2More:params2More inputCommentsStr:inputCommentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                
                //如果有入参组装函数，添加入参头部
                if (paramsAnalyzeStr.length) {
                    // var params = {
                    NSString * varBegin = [NSString stringWithFormat:@"\n%@%@var %@= %@\n",tab,tab,innerParams,lBrace];
                    paramsAnalyzeStr = [NSMutableString stringWithFormat:@"%@%@%@%@%@\n\n",varBegin,paramsAnalyzeStr,tab,tab,rBrace];
                }
                
                //如果外部包裹（inputParams），注释末尾添加 }
                if (params2More) {
                    [inputCommentsStr appendFormat:@"%@%@ }\n",tab,star];
                }
                
                //添加回调函数注释
                [inputCommentsStr appendFormat:@"%@%@ @param %-10s %-15s //-回调函数\n",tab,star,@"{func}".UTF8String,@"callBack".UTF8String];
                
                
                //添加函数入参，回调函数
                if (funcParamsStr.length) {
                    [funcParamsStr appendString:@","];
                }
                [funcParamsStr appendString:callBack];
                
                //生成最终的函数声明
                /**
                 test:function (inputParams,callBack)
                 */
                funcParamsStr = [NSMutableString stringWithFormat:@"%@%@:function (%@)",tab,identify,funcParamsStr];
                
                //组装整个函数部分 两个大括号中间的内容
                [funcBody appendString:@"  {\n"];
                [funcBody appendString:paramsAnalyzeStr];
                [funcBody appendFormat:@"%@%@this._callNative(\"%@\",params,callBack);\n",tab,tab,identify];
                [funcBody appendFormat:@"%@}",tab];
                
            }
        }else //如果没有入参添加固定格式
        {
            [inputCommentsStr appendFormat:@"%@/**\n",tab];
            
            
            NSString * fcComments =[commentsDic objectForKey:identify];
            if (fcComments) {
                
                [inputCommentsStr appendFormat:@"%@%@ %@\n",tab,star,fcComments];
            }
            [funcParamsStr appendFormat:@"%@%@:function (callBack) ",tab,identify];
            [funcBody appendString:@"  {\n"];
            [funcBody appendFormat:@"%@%@this._callNative(\"%@\",\"\",callBack);\n",tab,tab,identify];
            [funcBody appendFormat:@"%@}",tab];
        }
        
        
        //第二部分用于将输出参数从类中取出
        //生成注释中返回结果的信息
        [outputCommentsStr appendFormat:@"%@* \n",tab];
        [outputCommentsStr appendFormat:@"%@* ###输出信息如下###:\n",tab];
        [outputCommentsStr appendFormat:@"%@* callBackResponse = {\n",tab];
        [outputCommentsStr appendFormat:@"%@* %@responseObj = {\n",tab,tab];
        
        Class outputClz = routeOutPutClass[identify];
        if (outputClz) {
            NSDictionary * dic = [LXParamsInfoTree genParamsInfoTreeWithClass:outputClz];
            //递归生成子注释
            if (dic && [dic isKindOfClass:[NSDictionary class]])
            {
                [LXJSCodeGenerator setStrRecursiveWithValidateObject:dic outPutCommentsStr:outputCommentsStr];
                
            }
        }
        
        /**生成以下部分
         * }
         * error = {
         * errorCode: //String
         * errorMsg: //String
         * }
         *\/
         */
        [outputCommentsStr appendFormat:@"%@* %@}\n",tab,tab];
        [outputCommentsStr appendFormat:@"%@* %@error = {\n",tab,tab];
        [outputCommentsStr appendFormat:@"%@* %@%@%-15s: //String\n",tab,tab,tab,@"errorCode".UTF8String];
        [outputCommentsStr appendFormat:@"%@* %@%@%-15s: //String\n",tab,tab,tab,@"errorMsg".UTF8String];
        [outputCommentsStr appendFormat:@"%@* %@}\n",tab,tab];
        [outputCommentsStr appendFormat:@"%@* }\n",tab];
        [outputCommentsStr appendFormat:@"%@*/",tab];
        
        //第三部分 最终拼成整个函数代码
        NSString * functionStr = [NSString stringWithFormat:@" \n%@%@ \n \n%@%@  ,",inputCommentsStr,outputCommentsStr,funcParamsStr,funcBody ];
        [allJs appendString:functionStr];
        
    }
    
    [allJs appendString:baseJsPart2];
    
    [self getJSRelease:allJs finish:^(NSString *compressJS) {
        if (compressJS) {
            [releaseFileHandel writeData:[compressJS dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
    [fileHandel writeData:[allJs dataUsingEncoding:NSUTF8StringEncoding]];
}



//递归生成函数返回结果
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
            NSInteger level = annotation.level;
            NSMutableString * mtab = [NSMutableString string];
            level = level+1;
            while (level) {
                [mtab appendString:tab];
                level --;
            }
            NSDictionary * dic = [self mapDic];
            //自定义类型
            //String
            NSString * jsType;
            //{String}
            NSString * blockJSType;
            
            if (![NSObject isClassFromFoundation:NSClassFromString(annotation.typeName)]) {
                jsType = @"Object";
            }else
            {
                jsType = dic[annotation.typeName];
                if (!jsType) {
                    jsType = @"Undefine";
                }
            }
            blockJSType = [NSString stringWithFormat:@"{%@}",jsType];
            
            
            // *    isTest:  //NSNumber -是否测试
            [outPutCommentsStr appendFormat:@"%@%@%@%-15s: //%@ -%@ \n",tab,star,mtab,annotation.keyName.UTF8String,jsType,annotation.comments?:@""];
            //如果当前节点有子节点
            if (annotation.child) {
                
                //opts = [{
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [outPutCommentsStr appendFormat:@"%@%@%@%-15s = %@%@\n",tab,star,mtab,annotation.keyName.UTF8String,lSquareBracket,lBrace];
                }else//opts = {
                {
                    [outPutCommentsStr appendFormat:@"%@%@%@%-15s = %@\n",tab,star,mtab,annotation.keyName.UTF8String,lBrace];
                }
                
                [self setStrRecursiveWithValidateObject:annotation.child outPutCommentsStr:outPutCommentsStr];
                //结尾 }]
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [outPutCommentsStr appendFormat:@"%@%@%@%@%@\n",tab,star,mtab,rBrace,rSquareBracket];
                }else //结尾 }
                {
                    [outPutCommentsStr appendFormat:@"%@%@%@%@\n",tab,star,mtab,rBrace];
                }
                
            }
            
        }
        return YES;
    }
}

//递归生成输入注释，函数入参，函数组装
+(BOOL)setStrRecursiveWithParamsInfoTree:(id )json params2More:(BOOL)params2More inputCommentsStr:(NSMutableString *)commentsStr funcParamsStr:(NSMutableString *)funcParamsStr paramsAnalyzeStr:(NSMutableString *)paramsAnalyzeStr
{
    
    if([json isKindOfClass:[NSDictionary class]])//自定义对象
    {
        NSString * itemKey;
        NSEnumerator * dicEnumerator =[json keyEnumerator];
        while ((itemKey = [dicEnumerator nextObject] )!= nil) {
            id value = json[itemKey];
            [self setStrRecursiveWithParamsInfoTree:value params2More:params2More inputCommentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr ];
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
                    [self setStrRecursiveWithParamsInfoTree:value params2More:params2More inputCommentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
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
            if (![NSObject isClassFromFoundation:NSClassFromString(annotation.typeName)]) {
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
                    
                    
                    [commentsStr appendFormat:@"%@%@ @param %-10s %-15s //-%@ -%@ \n",tab,star,blockJSType.UTF8String,annotation.keyName.UTF8String,annotation.comments?:@"",annotation.required?@"(必输项)":@""];
                    
                    //isTest: isTest
                    [paramsAnalyzeStr appendFormat:@"%@%@%@%@:  %@,\n",tab,tab,tab,annotation.keyName,annotation.keyName];
                    
                }else//如果最外层是个对象
                {
                    
                    // *    isTest:  //NSNumber -是否测试
                    [commentsStr appendFormat:@"%@%@%@%-15s:  //%@ -%@ -%@ \n",tab,star,tab,annotation.keyName.UTF8String, jsType,annotation.comments?:@"",annotation.required?@"(必输项)":@""];
                    
                    //isTest: isTest
                    [paramsAnalyzeStr appendString:[NSString stringWithFormat:@"%@%@%@%@: %@.%@,\n",tab,tab,tab,annotation.keyName,funcParamsKey,annotation.keyName]];
                    
                }
                
            }else //第二级 第三级 ...
            {
                // *    isTest:  //NSNumber -是否测试
                [commentsStr appendFormat:@"%@%@%@%-15s:  //%@ -%@ -%@ \n",tab,star,mtab,annotation.keyName.UTF8String,jsType,annotation.comments?:@"",annotation.required?@"(必输项)":@""];
            }
            //如果当前节点有子节点
            if (annotation.child) {
                
                //opts = [{
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [commentsStr appendFormat:@"%@%@%@%@ = %@%@\n",tab,star,mtab,annotation.keyName,lSquareBracket,lBrace];
                }else//opts = {
                {
                    [commentsStr appendFormat:@"%@%@%@%@ = %@\n",tab,star,mtab,annotation.keyName,lBrace];
                }
                
                [self setStrRecursiveWithParamsInfoTree:annotation.child params2More:params2More inputCommentsStr:commentsStr funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                //结尾 }]
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    [commentsStr appendFormat:@"%@%@%@%@%@\n",tab,star,mtab,rBrace,rSquareBracket];
                }else //结尾 }
                {
                    [commentsStr appendFormat:@"%@%@%@%@\n",tab,star,mtab,rBrace];
                }
                
            }
            
        }
        return YES;
    }
}

+(void)getJSRelease:(NSString *) js finish:(void (^)(NSString * compressJS)) finish
{
    NSDictionary * dic = @{@"js_code":js,
                           @"compilation_level":@"WHITESPACE_ONLY",
                           @"output_format": @"text",
                           @"output_info" : @"compiled_code"
                           };

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/x-javascript", nil]];
    [manager POST:@"https://closure-compiler.appspot.com/compile" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *   _Nullable responseObject) {
    
        NSString * compressJS = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        finish(compressJS);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(nil);
    }];
}


+(void)genjsValidateHtml
{
    [LXJSCodeGenerator genjsValidateHtmlWithRouteHandles:[LXRouter sharedInstance].routeHandle RouteInputClass:[LXRouter sharedInstance].routeInputClass];
}

//生成验证html
+(void)genjsValidateHtmlWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass
{
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString * filePath = [NSString stringWithFormat:@"%@/sjt_JSTestRun.html",docDir];
    NSString * readPath = [[NSBundle mainBundle]pathForResource:@"sjt_JSTestBase" ofType:@"html"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:filePath error:nil];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    NSFileHandle * fileHandel = [NSFileHandle fileHandleForWritingAtPath:filePath];

    //用来取固定js的代码
    NSFileHandle * readHandel = [NSFileHandle fileHandleForReadingAtPath:readPath];
    NSData * baseJsData =[readHandel readDataToEndOfFile];
    NSString * baseJsStr = [[NSString alloc]initWithData:baseJsData encoding:NSUTF8StringEncoding];
    NSRange  range = [baseJsStr rangeOfString:part1End];
    //固定代码分为两部分，
    NSString * baseJsPart1 = [baseJsStr substringToIndex:range.location + range.length];
    NSString * baseJsPart2 = [baseJsStr substringFromIndex:range.location + range.length];
    [readHandel closeFile];
    
    //存储最终的js代码
    NSMutableString * allJs = [NSMutableString string];
    //添加上半部分固定代码
    [allJs appendString:baseJsPart1];
    
    NSEnumerator *  enumerator = [routeHandles keyEnumerator];
    NSString * identify;
    while ((identify = [enumerator nextObject]) !=nil) {
        
        //内部函数入参组装
        NSMutableString * paramsAnalyzeStr = [NSMutableString string];
        //函数入参字符串
        NSMutableString * funcParamsStr = [NSMutableString string];
        
        //通过输入类生成1.输入注释，2.函数入参，3.入参组装，4.调用部分
        Class inputClz = routeInputClass[identify];
        
        if (inputClz) {
            //根据类生成类的字典校验树，该树是生成注释和组装的基础
            NSDictionary * dic = [LXParamsInfoTree genParamsInfoTreeWithClass:inputClz];
            
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                
                /*js 函数定义为最多可传入5个参数，包含回调callBack，如果超过4个入参，就用对象（inputParams）包裹所有的入参**/
                BOOL params2More = dic.allKeys.count > 4;
                
                //如果参数被（inputParams）包裹，需要对注释，函数入参特殊处理
                if (params2More) {
                    //函数参数增加 inputParams
                    [funcParamsStr appendFormat:@"%@",funcParamsKey];
                    
                    //*inputParams = {
                    [paramsAnalyzeStr appendFormat:@"%@ %@ = { \n",tab,funcParamsKey];
                }
                
                //递归处理子节点,组装输入注释，函数入参，入参组装等
                [LXJSCodeGenerator setStrRecursiveWithParamsInfoTree:dic params2More:params2More  funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                
                //生成最终的函数声明
                /**
                 test:function (inputParams,callBack)
                 */
                funcParamsStr = [NSMutableString stringWithFormat:@"%@sjtApp.%@ (%@,function( callBackResponse ){LXLog('%@',callBackResponse.error)});",tab,identify,funcParamsStr,identify];
                
                if (params2More) {
                    [paramsAnalyzeStr appendFormat:@"%@ }\n",tab];
                }
            }
        }else //如果没有入参添加固定格式
        {
            [funcParamsStr appendFormat:@"%@sjtApp.%@(function( callBackResponse ){LXLog('%@',callBackResponse.error)}) ",tab,identify,identify];
        }
        
        
        //第三部分 最终拼成整个函数代码
        NSString * functionStr = [NSString stringWithFormat:@"\n%@\n%@ \n",paramsAnalyzeStr,funcParamsStr];
        [allJs appendString:functionStr];
        
    }
    
    [allJs appendString:baseJsPart2];
    [fileHandel writeData:[allJs dataUsingEncoding:NSUTF8StringEncoding]];
}

//递归生成输入注释，函数入参，函数组装
+(BOOL)setStrRecursiveWithParamsInfoTree:(id )json params2More:(BOOL)params2More funcParamsStr:(NSMutableString *)funcParamsStr paramsAnalyzeStr:(NSMutableString *)paramsAnalyzeStr
{
    
    if([json isKindOfClass:[NSDictionary class]])//自定义对象
    {
 
        NSString * itemKey;
        NSEnumerator * dicEnumerator =[json keyEnumerator];
        while ((itemKey = [dicEnumerator nextObject] )!= nil) {
            id value = json[itemKey];
            [self setStrRecursiveWithParamsInfoTree:value params2More:params2More funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr ];
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
                    [self setStrRecursiveWithParamsInfoTree:value params2More:params2More funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
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
            NSInteger level = annotation.level;
            NSMutableString * mtab = [NSMutableString string];
            while (level) {
                [mtab appendString:tab];
                level --;
            }

            if (!annotation.child) {
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
                        
                        
                        //var isTest = 'isTest';
                        [paramsAnalyzeStr appendFormat:@"%@%@var %@ = '%@';\n",tab,mtab,annotation.keyName,annotation.keyName];
                        
                    }else//如果最外层是个对象
                    {
                        //isTest: 'isTest'
                        [paramsAnalyzeStr appendString:[NSString stringWithFormat:@"%@%@%@:'%@',\n",tab,mtab,annotation.keyName,annotation.keyName]];
                    }
                    
                }else //第二级 第三级 ...
                {
                    // isTest:'isTest',
                    [paramsAnalyzeStr appendFormat:@"%@%@%@:'%@', \n",tab,mtab,annotation.keyName,annotation.keyName];
                }
            }
            //如果当前节点有子节点
            else{
                
                //opts = [{
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    
                    //最外层没有对象
                    if (!params2More && annotation.level == 1) {
                        [paramsAnalyzeStr appendFormat:@"%@%@var %@= %@%@\n",tab,mtab,annotation.keyName,lSquareBracket,lBrace];
                        
                        if (funcParamsStr.length) {
                            [funcParamsStr appendFormat:@",%@",annotation.keyName];
                        }else //第一个参数不需要 ,
                        {
                            [funcParamsStr appendFormat:@"%@",annotation.keyName];
                        }
                    }else
                    {
                        [paramsAnalyzeStr appendFormat:@"%@%@%@: %@%@\n",tab,mtab,annotation.keyName,lSquareBracket,lBrace];
                    }

                }else//opts = {
                {
                     if (!params2More && annotation.level == 1)
                     {
                         [paramsAnalyzeStr appendFormat:@"%@%@ var %@= %@\n",tab,mtab,annotation.keyName,lBrace];
                         
                         if (funcParamsStr.length) {
                             [funcParamsStr appendFormat:@",%@",annotation.keyName];
                         }else //第一个参数不需要 ,
                         {
                             [funcParamsStr appendFormat:@"%@",annotation.keyName];
                         }
                     }else
                     {
                         [paramsAnalyzeStr appendFormat:@"%@%@%@: %@\n",tab,mtab,annotation.keyName,lBrace];
                     }

                }
                
                [self setStrRecursiveWithParamsInfoTree:annotation.child params2More:params2More funcParamsStr:funcParamsStr paramsAnalyzeStr:paramsAnalyzeStr];
                //结尾 }]
                if ([annotation.typeName isEqualToString: NSStringFromClass([NSArray class])]) {
                    
                    
                    [paramsAnalyzeStr appendFormat:@"%@%@%@%@",tab,mtab,rBrace,rSquareBracket];
                    if (!params2More && annotation.level == 1) {
                        [paramsAnalyzeStr appendString:@";\n"];
                    }else
                    {
                        [paramsAnalyzeStr appendString:@",\n"];
                    }

                }else //结尾 }
                {
                    [paramsAnalyzeStr appendFormat:@"%@%@%@",tab,mtab,rBrace];
                    
                    if (!params2More && annotation.level == 1) {
                        [paramsAnalyzeStr appendString:@";\n"];
                    }else
                    {
                        [paramsAnalyzeStr appendString:@",\n"];
                    }

                }
                
            }
            
        }
        return YES;
    }
}
@end
