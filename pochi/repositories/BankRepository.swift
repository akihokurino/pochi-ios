//
//  BankRepository.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

// https://bank.teraren.com/
class BankRepository: ProvideTokenProtocol {
    static let shared = BankRepository()
    
    private var provider: RxMoyaProvider<BankApi> {
        return RxMoyaProvider<BankApi>()
    }
    
    private init() {
        
    }
    
    func fetchAll() -> Observable<[BankWithSection]> {
        return self.provider.request(.fetchAll)
            .filterError()
            .convertToJsonObservable()
            .map({ json -> [BankWithSection] in
                let allBanks: [Bank] = json.arrayValue.map({ BankResponse.from(json: $0).to() })
                return Bank.jisOrder.map({ c -> BankWithSection in
                    let banks = allBanks.filter({ bank -> Bool in
                        bank.kana.hasPrefix(c)
                    })
                    return BankWithSection(header: c, items: banks)
                }).filter({ !$0.items.isEmpty })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func fetch(bankCode: String) -> Observable<Bank> {
        return self.provider.request(.fetchBank(bankCode: bankCode))
            .filterError()
            .convertToJsonObservable()
            .map({ json -> Bank in
                return BankResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func fetch(bankCode: String, branchCode: String) -> Observable<Bank.Branch> {
        return self.provider.request(.fetchBranch(bankCode: bankCode, branchCode: branchCode))
            .filterError()
            .convertToJsonObservable()
            .map({ json -> Bank.Branch in
                return BankBranchResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}

