//商家通app js调用native脚本
var sjtApp= {
    CUSTOM_PROTOCOL_SCHEME : 'wbbpchannel',
    responseCallbacks :{},
    uniqueId : 1,
    //创建iframe
    _createIframe:function(){
        var  iframe=document.createElement("iframe");
        iframe.style.display="none";
        return iframe;
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
        
        var iframe=this._createIframe();
        iframe.src = this.CUSTOM_PROTOCOL_SCHEME + '://' + encodeURIComponent(messageQueueString);
        document.body.appendChild(iframe);
        setTimeout(function(){
                   document.body.removeChild(iframe);
                   iframe=null;
                   },200);
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
    * 打开本地页面
    * @param {Object}  inputParams
    * inputParams = { 
    *    jumpType       :  //String -1_native跳转2_web跳转 - 
    *    symbol         :  //String - - 
    *    params         :  //Object - - 
    *    params = {
    *        titleName      :  //String -埋点信息 - 
    *        isShowTitleBar :  //String -是否显示nativebar - 
    *        isShowClose    :  //String -是否显示关闭按钮 - 
    *    }
    *    url            :  //String -跳转的url - 
    *    markPointName  :  //String -埋点信息 - 
    * }
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    openNative:function (inputParams,callBack)  {

        var params= {
            jumpType: inputParams.jumpType,
            symbol: inputParams.symbol,
            params: inputParams.params,
            url: inputParams.url,
            markPointName: inputParams.markPointName,
        }

        this._callNative("openNative",params,callBack);
    }  , 
    /**
    * 跳转web页面
    * @param {String}   url             //-跳转的url - 
    * @param {String}   titleName       //-埋点信息 - 
    * @param {String}   isShowTitleBar  //-是否显示nativebar - 
    * @param {String}   isShowClose     //-是否显示关闭按钮 - 
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    openWebView:function (url,titleName,isShowTitleBar,isShowClose,callBack)  {

        var params= {
            url:  url,
            titleName:  titleName,
            isShowTitleBar:  isShowTitleBar,
            isShowClose:  isShowClose,
        }

        this._callNative("openWebView",params,callBack);
    }  , 
    /**
    * 调用native支付功能
    * @param {Object}  inputParams
    * inputParams = { 
    *    payfrom        :  //String -支付类型1微信2什么 - 
    *    productDesc    :  //String - - 
    *    payType        :  //String -支付类型1_58_2什么 - 
    *    balanceType    :  //String -支付类型1旧接口2新接口 - 
    *    orderMoney     :  //String -订单金额 -(必输项) 
    *    orderId        :  //String -订单id - 
    *    merId          :  //String - - 
    * }
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *        payNumber      : //String -支付号码 
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    pay58:function (inputParams,callBack)  {

        var params= {
            payfrom: inputParams.payfrom,
            productDesc: inputParams.productDesc,
            payType: inputParams.payType,
            balanceType: inputParams.balanceType,
            orderMoney: inputParams.orderMoney,
            orderId: inputParams.orderId,
            merId: inputParams.merId,
        }

        this._callNative("pay58",params,callBack);
    }  , 
    /**
    * 调用native支付功能
    * @param {String}   maxNum          //-最多可以上传多少张最少4张 - 
    * @param {String}   imageUrls       //-已上传的图片url - 
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *        imageUrls      : //String -已上传的图片url 
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    nativeImagePicker:function (maxNum,imageUrls,callBack)  {

        var params= {
            maxNum:  maxNum,
            imageUrls:  imageUrls,
        }

        this._callNative("nativeImagePicker",params,callBack);
    }  , 
    /**
    * 调用app埋点功能
    * @param {String}   countName       //-埋点信息 -(必输项) 
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    countEvent:function (countName,callBack)  {

        var params= {
            countName:  countName,
        }

        this._callNative("countEvent",params,callBack);
    }  , 
    /**
    * 发布商品
    * @param {String}   message         //-要发布的信息 - 
    * @param {Array}    imageProperty   //- - 
    *    imageProperty = [{
    *        width          :  //String -图片宽度 - 
    *        imageUrl       :  //String -图片url - 
    *        height         :  //String -图片高度 - 
    *        openNative     :  //Object - - 
    *        openNative = {
    *            jumpType       :  //String -1_native跳转2_web跳转 - 
    *            symbol         :  //String - - 
    *            params         :  //Object - - 
    *            params = {
    *                titleName      :  //String -埋点信息 - 
    *                isShowTitleBar :  //String -是否显示nativebar - 
    *                isShowClose    :  //String -是否显示关闭按钮 - 
    *            }
    *            url            :  //String -跳转的url - 
    *            markPointName  :  //String -埋点信息 - 
    *        }
    *    }]
    * @param {String}   markPointName   //-埋点信息 - 
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *        imageUrls      : //String -已上传的图片url 
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    postGoods:function (message,imageProperty,markPointName,callBack)  {

        var params= {
            message:  message,
            imageProperty:  imageProperty,
            markPointName:  markPointName,
        }

        this._callNative("postGoods",params,callBack);
    }  , 
    /**
    * 调用native支付功能
    * @param {Object}  inputParams
    * inputParams = { 
    *    payfrom        :  //String -支付类型1微信2什么 - 
    *    productDesc    :  //String - - 
    *    payType        :  //String -支付类型1_58_2什么 - 
    *    balanceType    :  //String -支付类型1旧接口2新接口 - 
    *    orderMoney     :  //String -订单金额 -(必输项) 
    *    orderId        :  //String -订单id - 
    *    merId          :  //String - - 
    * }
    * @param {func}     callBack        //-回调函数
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
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
    }  , 
    /**
    * 
    * ###输出信息如下###:
    * callBackResponse = {
    *     responseObj = {
    *     }
    *     error = {
    *         errorCode      : //String
    *         errorMsg       : //String
    *     }
    * }
    */ 
 
    backNative:function (callBack)   {
        this._callNative("backNative","",callBack);
    }  ,
    
    /**************end*******************/
}

