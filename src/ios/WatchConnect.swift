import WatchConnectivity
@objc(WatchConnect) class WatchConnect : CDVPlugin, WCSessionDelegate {
    
    var wcsession: WCSession!
    var callbackId: String = ""
    
    @objc(updateApplicationContext:)
    func updateApplicationContext(command: CDVInvokedUrlCommand){
        guard let callbackId = command.callbackId else { return }
        var pluginResult: CDVPluginResult
        let keyString = command.arguments[0] as! String
        let valueString = command.arguments[1] as! String
        do {
            try self.wcsession.updateApplicationContext([keyString : valueString])
        } catch {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "UPDATE_ERROR")
            self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
        }
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "CONTEXT_UPDATED")
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
    
    @objc(initialize:)
    func initialize(command: CDVInvokedUrlCommand){
        guard let callbackId = command.callbackId else { return }
        self.callbackId = callbackId
        if(WCSession.isSupported()){
            self.wcsession = WCSession.default
            self.wcsession.delegate = self
            self.wcsession.activate()
        }else{
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "WCSESSION_NOT_SUPPORTED")
            self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
        }
    }
    
    @objc(deinitialize:)
    func deinitialize(command: CDVInvokedUrlCommand){
        guard let callbackId = command.callbackId else { return }
        var pluginResult: CDVPluginResult
        self.wcsession = nil
        self.callbackId = ""
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
    
    @objc(checkConnection:)
    func checkConnection(command: CDVInvokedUrlCommand){
        guard let callbackId = command.callbackId else { return }
        var pluginResult: CDVPluginResult
        if(self.wcsession.isPaired && self.wcsession.isReachable && self.wcsession.isWatchAppInstalled){
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        }else{
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "APPLE_WATCH_NOT_AVAILABLE")
        }
        self.commandDelegate.send(pluginResult, callbackId: callbackId)
    }
    
    @objc(sendMessage:)
    func sendMessage(command: CDVInvokedUrlCommand){
        guard let callbackId = command.callbackId else { return }
        let message = ["message": command.arguments[0]]
        self.sendM(callbackId: callbackId, message: message)
    }
    
    @objc(listenMessage:)
    func listenMessage(command: CDVInvokedUrlCommand){
        guard let callbackId = command.callbackId else { return }
        self.callbackId = callbackId
    }
    
    func sendM(callbackId: String, message: [String : Any]){
        var pluginResult: CDVPluginResult
        if(WCSession.isSupported()){
            if(self.wcsession.isPaired && self.wcsession.isReachable && self.wcsession.isWatchAppInstalled){
                self.wcsession.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    var pluginResult: CDVPluginResult
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "MESSAGE_SEND_FAIL")
                    self.commandDelegate.send(pluginResult, callbackId: callbackId)
                })
            }else{
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "APPLE_WATCH_NOT_AVAILABLE")
                self.commandDelegate.send(pluginResult, callbackId: callbackId)
            }
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "MESSAGE_SENT")
            self.commandDelegate.send(pluginResult, callbackId: callbackId)
        }else{
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "WCSESSION_NOT_SUPPORTED")
            self.commandDelegate.send(pluginResult, callbackId: callbackId)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        var pluginResult: CDVPluginResult
        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
        pluginResult.setKeepCallbackAs(true)
        self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        var pluginResult: CDVPluginResult
        do {
            let contents = try String(contentsOf: file.fileURL)
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: contents)
            pluginResult.setKeepCallbackAs(true)
            self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
        } catch let err {
            print(String(describing: err.localizedDescription))
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "FILE_CONTENTS_ERROR")
            self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
        }
    }
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession sessionDidBecomeInactive")
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession sessionDidDeactivate")
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activationDidCompleteWith activationState: \(activationState.rawValue)")
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "WCSESSION_ACTIVATED")
        self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
        if error != nil {
            print("WCSession activationDidCompleteWith ERROR: \(String(describing: error))")
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "WCSESSION_NOT_ACTIVATED")
            self.commandDelegate.send(pluginResult, callbackId: self.callbackId)
        }
    }
}
