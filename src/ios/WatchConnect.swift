import WatchConnectivity
@objc(WatchConnect) class WatchConnect : CDVPlugin, WCSessionDelegate {
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")
    }
    public func sessionDidDeactivate(_ session: WCSession) {
        print("deactivate")
    }
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
        print("activation")
        if error != nil {
            print(error ?? "")
        }
    }
    
    var wcsession: WCSession!
    var messageReceiver: String = ""
    var callback: String = ""
    
    @objc(initialize:)
    func initialize(command: CDVInvokedUrlCommand){
        let callbackID = command.callbackId
        var pluginResult: CDVPluginResult
        if(WCSession.isSupported()){
            self.wcsession = WCSession.default
            self.wcsession.delegate = self
            self.wcsession.activate()
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        }else{
            self.alert(msg: "WCSession not supported")
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
            
        }
        self.commandDelegate.send(pluginResult, callbackId: callbackID)
    }
    
    @objc(checkConnection:)
    func checkConnection(command: CDVInvokedUrlCommand){
        let callbackID = command.callbackId
        self.callback = callbackID!
        if(WCSession.isSupported()){
            let message = ["message": "check"]
            self.wcsession.sendMessage(message, replyHandler: nil, errorHandler: { error in
                self.alert(msg: "Apple Watch not available")
                var pluginResult: CDVPluginResult
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            })
        }
    }
    
    @objc(deinitialize:)
    func deinitialize(command: CDVInvokedUrlCommand){
        let callbackID = command.callbackId
        var pluginResult: CDVPluginResult
        self.wcsession = nil
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: callbackID)
    }
    
    @objc(sendMessage:)
    func sendMessage(command: CDVInvokedUrlCommand){
        let callbackID = command.callbackId
        var pluginResult: CDVPluginResult
        if(WCSession.isSupported()){
            let message = ["message": command.arguments[0]]
            if(self.wcsession.isPaired && wcsession.isReachable && wcsession.isWatchAppInstalled){
                self.wcsession.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    self.alert(msg: "Apple Watch not available")
                    var pluginResult: CDVPluginResult
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
                    self.commandDelegate.send(pluginResult, callbackId: callbackID)
                })
            }else{
                self.alert(msg: "Apple Watch not available")
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate.send(pluginResult, callbackId: callbackID)
        }else{
            self.alert(msg: "WCSession not supported")
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR)
            self.commandDelegate.send(pluginResult, callbackId: callbackID)
        }
    }
    
    @objc(listenMessage:)
    func listenMessage(command: CDVInvokedUrlCommand){
        let callbackID = command.callbackId
        self.messageReceiver = callbackID!
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        var pluginResult: CDVPluginResult
        let msg = message["reply"] as! String
        if(msg == "check"){
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate.send(pluginResult, callbackId: self.callback)
        }else{
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
            pluginResult.setKeepCallbackAs(true)
            self.commandDelegate.send(pluginResult, callbackId: self.messageReceiver)
        }
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        var pluginResult: CDVPluginResult
        do {
            let contents = try String(contentsOf: file.fileURL)
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: contents)
            self.commandDelegate.send(pluginResult, callbackId: self.messageReceiver)
        } catch let err {
            self.alert(msg: String(describing: err.localizedDescription))
        }
    }
    
    func alert(msg: String){
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: msg, message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertView.addAction(action)
            self.viewController.present(alertView, animated: true, completion: nil)
        }
    }
    
}