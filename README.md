# Cordova Watch Connect Swift plugin

This plugin helps you communicate between Ionic/Cordova iOS app and Apple Watch

## Install:
```bash
$ ionic cordova plugin add https://github.com/gecsbernat/cordova-plugin-watchconnect-swift.git
```

## Use:

### Ionic:
```typescript
import { Injectable } from "@angular/core";
import { Platform } from "@ionic/angular";
import { Observable } from "rxjs";
declare var WatchConnect: any;

@Injectable({ providedIn: 'root' })
export class AppleWatchConnectService {

    watchConnectEnabled = false;

    constructor(
        private platform: Platform
    ) { }

    initializeAppleWatchConnection(): Promise<any> {
        return new Promise((resolve, reject) => {
            if (this.platform.is('cordova') && this.platform.is('ios')) {
                WatchConnect.initialize((success: any) => {
                    this.watchConnectEnabled = true;
                    resolve(success)
                }, (error: any) => {
                    this.watchConnectEnabled = false;
                    reject(error);
                });
            } else {
                this.watchConnectEnabled = false;
                reject('NOT_CORDOVA_ON_IOS');
            }
        });
    }

    listenMessage(): Observable<any> {
        return new Observable((observer) => {
            if (this.watchConnectEnabled) {
                WatchConnect.listenMessage((message: any) => {
                    observer.next(message);
                }, (error: any) => {
                    observer.error(error);
                });
            } else {
                observer.error('WATCH_CONNECT_NOT_ENABLED');
            }
        });
    }

    sendMessage(message: string): Promise<any> {
        return new Promise((resolve, reject) => {
            if (this.watchConnectEnabled) {
                WatchConnect.sendMessage(message, (success: any) => {
                    resolve(success);
                }, (error: any) => {
                    reject(error);
                });
            } else {
                reject('WATCH_CONNECT_NOT_ENABLED');
            }
        });
    }

    updateApplicationContext(keyString: string, valueString: string): Promise<any> {
        return new Promise((resolve, reject) => {
            if (this.watchConnectEnabled) {
                WatchConnect.updateApplicationContext(keyString, valueString, (success: any) => {
                    console.log(success);
                    resolve(success);
                }, (error: any) => {
                    reject(error);
                });
            } else {
                reject('WATCH_CONNECT_NOT_ENABLED');
            }
        });
    }
}
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
