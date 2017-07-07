//
//  NSString.swift
//  SyncPostSwift
//
//  Created by Dmitry Feld on 7/7/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

import Foundation

extension NSString {
    class func string(withDeviceID deviceID:NSData)->NSString? {
        var result: NSString? = nil
        if 0 != deviceID.length {
            result = NSString(format:"%@",deviceID)
            result = result?.replacingOccurrences(of: " ", with: "") as NSString?
            result = result?.replacingOccurrences(of: "<", with: "") as NSString?
            result = result?.replacingOccurrences(of: ">", with: "") as NSString?
        }
        return result
    }
}
