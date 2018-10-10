//
//  MapDelegate.swift
//  pochi
//
//  Created by akiho on 2017/03/14.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class MapDelegate {
    
    private init() {
        
    }
    
    static func openGoogleMap(latitude: Double, longitude: Double) {
        UIApplication.shared.open(
            NSURL(string: "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14")! as URL,
            options: [:],
            completionHandler: nil)
    }
    
    static func openAppleMap(latitude: Double, longitude: Double) {
        let daddr = NSString(format: "%f,%f", latitude, longitude)
        let urlString = "http://maps.apple.com/?daddr=\(daddr)&dirflg=d"
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        UIApplication.shared.open(
            NSURL(string: encodedUrl!)! as URL,
            options: [:],
            completionHandler: nil)
    }
}
