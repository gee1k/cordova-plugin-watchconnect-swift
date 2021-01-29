# Cordova Watch Connect Swift plugin

This plugin helps you communicate between Ionic/Cordova iOS app and Apple Watch

## Install:
```bash
$ cordova plugin add https://github.com/gecsbernat/cordova-plugin-watchconnect-swift.git
```

## Use:

### Ionic:
```js
WatchConnect.initialize((success: any) => {
    console.log(success);
    WatchConnect.listenMessage((message: any) => {
        console.log(message);
    }, (error: any) => {
        console.log(error);
    });
}, (error: any) => {
    console.log(error);
});


WatchConnect.sendMessage(message, (success: any) => {
    console.log(success);
}, (error: any) => {
    console.log(error);
});


WatchConnect.updateApplicationContext(keyString, valueString, (success: any) => {
    console.log(success);
}, (error: any) => {
    console.log(error);
});
```

### Swift:
InterfaceController.swift:
```swift
import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var wcsession: WCSession!
    
    override func awake(withContext context: Any?) {}
    
    override func willActivate() {
        wcsession = WCSession.default
        wcsession.delegate = self
        wcsession.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message["message"] as! String)
        wcsession.sendMessage(["reply":"reply"], replyHandler: nil) { (Error) in
            print(Error)
        }
    }
    
    override func didDeactivate() {}
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?){}
}
```

Add new Watchkit target in xCode:
* File -> New -> Target... -> watchOS / Watch App for iOS App
* Fill options

If you get this error:
```
'Cordova/CDV.h' file not found
```
* Remove Bridging-Header from Watchkit Extension target's Build Settings / Swift Compiler General
