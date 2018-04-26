# LXRouter
IOS router 和 jsBridge的综合解决方案。具有以下特点：
一. 路由调用方可以使用model作为入参执行路由，减少硬编码。
二. LXRouterTools 根据注册内容生成jsBridge脚本，脚本注释明确，无需说明文档。可以供前端直接使用。
三. LXRouterTools 生成jsBridge相应的校验脚本，保证jsBridge的接口正确性。
四. 路由具有参数校验功能，协助前端调试。


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


