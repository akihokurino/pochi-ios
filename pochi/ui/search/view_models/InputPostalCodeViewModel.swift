//
//  InputPostalCodeViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class InputPostalCodeViewModel {
    private(set) var currentZipCode: String = ""
    
    func bind(data: InputPostalCodeData.SendData) {
        currentZipCode = data.postalCode
    }
}
