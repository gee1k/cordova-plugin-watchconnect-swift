# Cordova Watch Connect Swift plugin

This plugin helps you communicate between Ionic/Cordova iOS app and Apple Watch

## Install:
```bash
$ cordova platform add ios
$ cordova plugin add cordova-plugin-add-swift-support --save
$ cordova plugin add ........git
```

## Use:

### Ionic:
```js
WatchConnect.initialize((onSuccess) => {
    WatchConnect.listenMessage((message) => {
        console.log("Message from watch: "+message);
    }, (onError)=>{
        console.log("error");
    });
});
WatchConnect.sendMessage("test");
```

### Swift:
DEMOAPP/platforms/ios/MyApp.xcodeproj

File/New/Target/WatchOS/WatchKit App

WatchApp és WatchKit extension Build settings-nél ki kell venni a bridging header fájlt!

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