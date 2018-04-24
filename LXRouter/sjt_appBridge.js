//商家通app js调用native脚本
var sjtApp= {
    messagingIframe : "",
    CUSTOM_PROTOCOL_SCHEME : 'wbbpchannel',
    responseCallbacks :{},
    uniqueId : 1,
    //创建iframe
    _createQueueReadyIframe:function(doc) {
        this.messagingIframe = doc.createElement('iframe');
        this.messagingIframe.style.display = 'none';
        doc.documentElement.appendChild(this.messagingIframe);
    },
    //内部函数不要使用
    _callNative:function(action, params, responseCallback) {
        this._doSend({
            function: action,
            params: params
        }, responseCallback);
    },
    //内部函数不要使用
    _doSend:function (message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'hy_' + (this.uniqueId++) + '_' + new Date().getTime();
            this.responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }
        var messageQueueString = JSON.stringify(message);
        this.messagingIframe.src = this.CUSTOM_PROTOCOL_SCHEME + '://' + encodeURIComponent(messageQueueString);
    },
    //内部函数不要使用
    _dispatchMessageFromNative:function (messageJSON) {
        (function(that){setTimeout(function() {
            var message = JSON.parse(messageJSON);
            var responseCallback;
            if (message.responseId) {
                responseCallback = that.responseCallbacks[message.responseId];
               
                if (!responseCallback) {
                    return;
                }
                responseCallback(message.responseData);
                delete that.responseCallbacks[message.responseId];
            }
        })})(this);
    },
    
    //供外部调用的函数从此开始
    /**************begin*****************/ 
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
    * responseObj = {
    *    payfrom:  //String -支付类型1微信2什么 
    *    productDesc:  //String - 
    *    payType:  //String - 
    *    balanceType:  //String -支付类型1旧接口2新接口 
    *    orderMoney:  //String -订单金额 
    *    orderId:  //String -订单id 
    *    merId:  //String - 
    * }
    * error = {
    * errorCode: //String
    * errorMsg: //String
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
    }  , 
    /**
    * @param {Object}  inputParams
    * inputParams = { 
    *    isTest:  //String -是否测试 -(必输项) 
    *    urls:  //Array - -(必输项) 
    *    hhh:  //Object - -(必输项) 
    *    hhh = {
    *        aaaa:  //String - - 
    *        date:  //String - - 
    *        data:  //Undefine - - 
    *        number:  //String - -(必输项) 
    *    }
    *    array:  //Array - -(必输项) 
    *    array = [{
    *        aaaa:  //String - - 
    *        date:  //String - - 
    *        data:  //Undefine - - 
    *        number:  //String - -(必输项) 
    *    }]
    *    test:  //String - -(必输项) 
    *    test2:  //String - -(必输项) 
    * }
    * @param {func}     callBack -回调函数
    * 
    * ###输出信息如下###:
    * responseObj = {
    *    aaaa:  //String - 
    *    date:  //String - 
    *    data:  //Undefine - 
    *    number:  //String - 
    * }
    * error = {
    * errorCode: //String
    * errorMsg: //String
    * }
    */ 
 
    test:function (inputParams,callBack)  {

        var params= {
            isTest: inputParams.isTest,
            urls: inputParams.urls,
            hhh: inputParams.hhh,
            array: inputParams.array,
            test: inputParams.test,
            test2: inputParams.test2,
        }

        this._callNative("test",params,callBack);
    }  , 
    /**
    * @param {String}   aaaa 
    * @param {String}   date 
    * @param {Undefine} data 
    * @param {String}   number 
    * @param {func}     callBack -回调函数
    * 
    * ###输出信息如下###:
    * responseObj = {
    *    isTest:  //String -是否测试 
    *    urls:  //Array - 
    *    hhh:  //Object - 
    *    hhh = {
    *        aaaa:  //String - 
    *        date:  //String - 
    *        data:  //Undefine - 
    *        number:  //String - 
    *    }
    *    array:  //Array - 
    *    array = [{
    *        aaaa:  //String - 
    *        date:  //String - 
    *        data:  //Undefine - 
    *        number:  //String - 
    *    }]
    *    test:  //String - 
    *    test2:  //String - 
    * }
    * error = {
    * errorCode: //String
    * errorMsg: //String
    * }
    */ 
 
    test2:function (aaaa,date,data,number,callBack)  {

        var params= {
            aaaa:  aaaa,
            date:  date,
            data:  data,
            number:  number,
        }

        this._callNative("test2",params,callBack);
    }  , 
    /**
    * 
    * ###输出信息如下###:
    * responseObj = {
    * }
    * error = {
    * errorCode: //String
    * errorMsg: //String
    * }
    */ 
 
    dianyixia:function (callBack)   {
        this._callNative("dianyixia","",callBack);
    }  , 
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
    * responseObj = {
    * }
    * error = {
    * errorCode: //String
    * errorMsg: //String
    * }
    */ 
 
    callNativePay:function (inputParams,callBack)  {

        var params= {
            payfrom: inputParams.payfrom,
            productDesc: inputParams.productDesc,
            payType: inputParams.payType,
            balanceType: inputParams.balanceType,
            orderMoney: inputParams.orderMoney,
            orderId: inputParams.orderId,
            merId: inputParams.merId,
        }

        this._callNative("callNativePay",params,callBack);
    }  ,
    
    /**************end*******************/
}
    var doc = document;
    sjtApp._createQueueReadyIframe(doc);

