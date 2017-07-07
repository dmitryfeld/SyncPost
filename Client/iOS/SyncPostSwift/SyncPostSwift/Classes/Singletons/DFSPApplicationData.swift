//
//  DFSPApplicationData.swift
//  SyncPostSwift
//
//  Created by Dmitry Feld on 7/7/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

import UIKit

class DFSPApplicationData: NSObject {
    private var _apnsPushToken: NSString?
    private static var _sharedApplicationData:DFSPApplicationData?
    public var apnsPushToken: NSString? {
        get {
            return self._apnsPushToken as NSString?
        }
        set {
            self._apnsPushToken = apnsPushToken
        }
    }
    static func shared() -> DFSPApplicationData! {
        if nil == _sharedApplicationData {
            _sharedApplicationData = DFSPApplicationData()
        }
        return _sharedApplicationData
    }
}
