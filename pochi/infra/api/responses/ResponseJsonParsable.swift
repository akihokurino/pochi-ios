//
//  Response.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ResponseJsonParsable {
    static func from(json: JSON!) -> Self
}
