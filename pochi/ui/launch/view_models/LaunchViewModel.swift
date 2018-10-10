//
//  LaunchViewModel.swift
//  pochi
//
//  Created by akiho on 2017/04/30.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class LaunchViewModel {
    func setupPublicAsset() -> Observable<Void> {
        return PublicAssetRepository.shared.setup()
    }
}
