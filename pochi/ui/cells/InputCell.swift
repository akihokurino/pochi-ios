//
//  InputCell.swift
//  pochi
//
//  Created by akiho on 2017/02/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

protocol InputCell {
    func getInput() -> UITextInput
    func sync(data: InputCellData)
}
