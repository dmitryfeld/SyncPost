//
//  DFSPPushNotificationSupport.swift
//  SyncPostSwift
//
//  Created by Dmitry Feld on 7/7/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

import UIKit



class DFSPPushNotificationSupport: NSObject {
    private var _owner: UIApplication
    private var _lastError: NSError?
    private var _deviceToken: NSString?
    
    init(withApplication owner:UIApplication) {
        self._owner = owner
    }
    func startRegistration() {
        self._owner.registerForRemoteNotifications()
    }
    func onFailedWithError(error:NSError!) {
        self._lastError = error
        NSLog("APNS ERROR: %@", error)
    }
    func onDidRegisterWithToken(token:NSData) {
        _deviceToken = NSString.string(withDeviceID: token)
        DFSPApplicationData.shared().apnsPushToken = _deviceToken
        NSLog("APNS TOKEN: %@", _deviceToken ?? "nil")
    }
    func onDidReceive(notification dict:[AnyHashable : Any]!, fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("APNS RECEIVED: %@", dict)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    public var lastError: NSError? {
        get {
            return self._lastError
        }
    }
}
