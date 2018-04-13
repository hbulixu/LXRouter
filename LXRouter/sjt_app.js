var sjtApp={

    var messagingIframe;
    var CUSTOM_PROTOCOL_SCHEME = 'wbbpchannel';

    var responseCallbacks = {};
    var uniqueId = 1;
    //创建iframe
    _createQueueReadyIframe:function(doc) {
        messagingIframe = doc.createElement('iframe');
        messagingIframe.style.display = 'none';
        doc.documentElement.appendChild(messagingIframe);
    },

    _callNative:function(function, params, responseCallback) {
        _doSend({
            function: action,
            params: params
        }, responseCallback);
    },

    _doSend:function (message, responseCallback) {
        if (responseCallback) {
            var callbackId = 'hy_' + (uniqueId++) + '_' + new Date().getTime();
            responseCallbacks[callbackId] = responseCallback;
            message.callbackId = callbackId;
        }
        var messageQueueString = JSON.stringify(message);
        messagingIframe.src = CUSTOM_PROTOCOL_SCHEME + '://' + encodeURIComponent(messageQueueString);
    },


    _dispatchMessageFromNative:function (messageJSON) {
        setTimeout(function() {
            var message = JSON.parse(messageJSON);
            var responseCallback;
            //java call finished, now need to call js callback function
            if (message.responseId) {
                responseCallback = responseCallbacks[message.responseId];
                if (!responseCallback) {
                    return;
                }
                responseCallback(message.responseData);
                delete responseCallbacks[message.responseId];
            } 
        });
    }

	var doc = document;
    _createQueueReadyIframe(doc);

}