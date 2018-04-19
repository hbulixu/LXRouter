 
    /**
    * @param {String}   aaaa 
    * @param {String}   date 
    * @param {Undefine} data 
    * @param {String}   number 
    * @param {func}     callBack -回调函数
    */ 
 
    test2:function (aaaa,date,data,number,callBack)  {

        var params= {
            aaaa:  aaaa
            date:  date
            data:  data
            number:  number
        }

        this._callNative("test2",params,callBack);
    }   
    /**
    * @param {Object}  inputParams
    * inputParams = { 
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
    * @param {func}     callBack -回调函数
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
    }  cks[message.responseId];
               
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

