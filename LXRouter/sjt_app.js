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
    
    /**************end*******************/
}
    var doc = document;
    sjtApp._createQueueReadyIframe(doc);

