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

    _callNative:function(action, params, responseCallback) {
        this._doSend({
            function: action,
            params: params
        }, responseCallback);
    },

    _doSend:function (message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'hy_' + (this.uniqueId++) + '_' + new Date().getTime();
            this.responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }
        var messageQueueString = JSON.stringify(message);
        this.messagingIframe.src = this.CUSTOM_PROTOCOL_SCHEME + '://' + encodeURIComponent(messageQueueString);
    },


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
    
    test2:function(aaaa,date,data,number,callBack)
    {
        var params= {
        aaaa:  aaaa,
        date:  date,
        data:  data,
        number:  number
        }
        this._callNative("test2",params,callBack);
    },

    test:function(inputParams,callBack )
    {
        var params ={
        isTest: inputParams.isTest,
        urls: inputParams.urls,
        hhh: inputParams.hhh,
        array: inputParams.array,
        test: inputParams.test,
        test2: inputParams.test2,
        }
        this._callNative("test",params,callBack);
    }
}

    var doc = document;
    sjtApp._createQueueReadyIframe(doc);

function hello(){
    sjtApp._dispatchMessageFromNative(null);
}

