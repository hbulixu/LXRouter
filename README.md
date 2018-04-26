# LXRouter
IOS router 和 jsBridge的综合解决方案。具有以下特点：<br>
一. 路由调用方可以使用model作为入参执行路由，减少硬编码。<br>
二. LXRouterTools 根据注册内容生成jsBridge脚本，脚本注释明确，无需说明文档。可以供前端直接使用。<br>
三. LXRouterTools 生成jsBridge相应的校验脚本，保证jsBridge的接口正确性。<br>
四. 路由具有参数校验功能，协助前端调试。<br>

WebViewJavascriptBridge 是常用的native和js交互方案。优点众多，就不说明了，简单说一下使用当中的缺点。<br>
1.硬编码严重，对于参数较多，较复杂的情况下使用不便。<br>
2.只局限于web端调用，无法在native中使用路由，不符合大路由的思路。<br>
3.对接口说明文档要求较高。调试耗时。<br>

现有的一些做法：<br>
1.每个路由调用都生成独立的方法，通过内部组装减少硬编码。<br>
2.维护一套完善的js使用文档，给使用者。<br>
3.剥离出jsbridge解析模块，与路由衔接，使得路由不局限于web端调用。<br>

以上做法依然有问题，就js和js文档维护就消耗很多人力。LXRouter就是为解决以上问题开发的。<br>




注意：demo中使用系统邮件导出沙盒中生成的js脚本，如果邮件设置繁琐，可以修改脚本路径到工程目录，在调试模式下生成文件到工程目录。修改以下代码：
LXJSCodeGenerator.m
```
+(void)genScriptBridgeWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass RouteOutPutClass:(NSDictionary *)routeOutPutClass
{
NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//修改该路径为本地工程路径
NSString * filePath = [NSString stringWithFormat:@"%@/sjt_appBridge.js",docDir];



+(void)genjsValidateHtmlWithRouteHandles:(NSDictionary *)routeHandles RouteInputClass:(NSDictionary *)routeInputClass
{

NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//修改该路径为本地工程路径
NSString * filePath = [NSString stringWithFormat:@"%@/sjt_JSTestRun.html",docDir];
```

使用方式：

1.生成路由输入输出model

```
#import "TypeAnnotation.h"
@interface SJTPayModel : NSObject
FCComments(调用native支付功能)
PRComments(订单金额)
ParamRequired
@property (nonatomic,copy)NSString * orderMoney;
PRComments(支付类型1_58_2什么)
@property (nonatomic,copy)NSString * payType;
PRComments(支付类型1旧接口2新接口)
@property (nonatomic,copy)NSString * balanceType;
PRComments(支付类型1微信2什么)
@property (nonatomic,copy)NSString * payfrom;
@property (nonatomic,copy)NSString * merId;
PRComments(订单id)
@property (nonatomic,copy)NSString * orderId;
@property (nonatomic,copy)NSString * productDesc;
@end
```

2.注册路由
```
[LXRouter registerIdentify:@"nativePay" inputClass:[SJTPayModel class] outputClass:nil toHandler:^(LXRouterInfo *routerInfo) {
    NSLog(@"%@",((TestObj *)routerInfo.inputModel).lx_modelToJSONObject);
}];
```

3.生成jsbridge脚本和验证脚本
```
[LXRouterTools genJavaScriptBridge];
[LXRouterTools genjsValidateHtml];
```
4.生成脚本中的部分代码如下
```
/**
* 调用native支付功能
* @param {Object}  inputParams
* inputParams = { 
*    payfrom:  //String -支付类型1微信2什么 - 
*    productDesc:  //String - - 
*    payType:  //String - - 
*    balanceType:  //String -支付类型1旧接口2新接口 - 
*    orderMoney:  //String -订单金额 -(必输项) 
*    orderId:  //String -订单id - 
*    merId:  //String - - 
* }
* @param {func}     callBack -回调函数
* 
* ###输出信息如下###:
* callBackResponse = {
*     }
*     error = {
*         errorCode: //String
*         errorMsg: //String
*     }
* }
*/ 

nativePay:function (inputParams,callBack)  {

var params= {
    payfrom: inputParams.payfrom,
    productDesc: inputParams.productDesc,
    payType: inputParams.payType,
    balanceType: inputParams.balanceType,
    orderMoney: inputParams.orderMoney,
    orderId: inputParams.orderId,
    merId: inputParams.merId,
}

this._callNative("nativePay",params,callBack);
}  
```




