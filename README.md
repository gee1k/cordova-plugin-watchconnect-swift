Cordova Apple WatchConnectivity Plugin

Ez a plugin az Apple "WatchConnectivity" framework használatával kommunikál natív watchOS app és IONIC/Cordova iPhone app között.
Előnye, hogy nincs szükség App Group használatára mint az MMWormhole esetében.

======
## Telepítés:
```bash
$ ionic start DEMOAPP blank
$ cd DEMOAPP
$ cordova plugin add cordova-plugin-add-swift-support --save
$ cordova platform add ios
$ cordova plugin add https://gbernat@stash.sed.hu/scm/isp/cordova-applewatch-watchconnectivity-plugin.git
```

## Használat:

### Typescript:
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

### Xcode:
DEMOAPP/platforms/ios/MyApp.xcodeproj
File/New/Target/WatchOS/WatchKit App
WatchApp és WatchKit extension Build settings-nél ki kell venni a bridging header fájlt!

InterfaceController.swift:
```swift
import WatchConnectivity
class InterfaceController: WKInterfaceController, WCSessionDelegate{
    var wcsession: WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()

        wcsession = WCSession.default()
        wcsession.delegate = self
        wcsession.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message["message"] as! String)
        wcsession.sendMessage(["reply":"reply"], replyHandler: nil) { (Error) in
            print(Error)
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith    activationState: WCSessionActivationState, error: Error?) {
    }
}
```

```bash
$ ionic cordova run ios  //BUILD ERROR a watch target miatt.
```

### Xcode:
Futtatás simulatorban.

###### Gécs Bernát
###### Felhasznált források:
 Obj-c alapú plugin: https://github.com/DVenkatesh/cordova-plugin-watchconnectivity