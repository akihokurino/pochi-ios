//
//  BankAccountRepository.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class BankAccountRepository: ProvideTokenProtocol {
    static let shared = BankAccountRepository()
    
    private var provider: RxMoyaProvider<BankAccountApi> {
        return RxMoyaProvider<BankAccountApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetchAll() -> Observable<[BankAccount]> {
        let appUser = AppUserStore.shared.restore()!
        
        return self.provider.request(.fetchAll(userId: appUser.overview.id))
            .filterError()
            .convertToJsonObservable()
            .map({ json -> [BankAccount] in
                return ItemsResponse<BankAccountResponse>.from(json: json).items.map({ $0.to() })
            })
            .flatMap({ accounts -> Observable<[BankAccount]> in
                if accounts.isEmpty {
                    return Observable.just(accounts)
                }
                
                var requests: [Observable<Bank>] = []
                accounts.forEach {
                    requests.append(BankRepository.shared.fetch(bankCode: $0.bankCode))
                }
                
                return Observable.combineLatest(requests, { banks in
                    accounts.forEach { account in
                        banks.forEach { bank in
                            if account.bankCode == bank.code {
                                account.bank = bank
                            }
                        }
                    }
                    
                    return accounts
                })
            })
            .flatMap({ accounts -> Observable<[BankAccount]> in
                if accounts.isEmpty {
                    return Observable.just(accounts)
                }
                
                var requests: [Observable<Bank.Branch>] = []
                accounts.forEach {
                    requests.append(BankRepository.shared.fetch(bankCode: $0.bankCode, branchCode: $0.branchCode))
                }
                
                return Observable.combineLatest(requests, { branches in
                    accounts.forEach { account in
                        branches.forEach { branch in
                            if account.branchCode == branch.code {
                                account.branch = branch
                            }
                        }
                    }
                    
                    return accounts
                })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func create(data: CreateBankAccountData.SendData, bank: Bank) -> Observable<BankAccount> {
        let appUser = AppUserStore.shared.restore()!
        let requestData = CreateBankAccountRequest(recipientType: data.recipientType,
                                                   accountType: data.accountType,
                                                   bankCode: bank.code,
                                                   branchCode: data.branchCode,
                                                   number: data.number,
                                                   name: data.name)
        return self.provider.request(.create(userId: appUser.overview.id, data: requestData))
            .filterError()
            .convertToJsonObservable()
            .map({ json -> BankAccount in
                return BankAccountResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func transfer(point: Int64, account: BankAccount) -> Observable<Void> {
        let appUser = AppUserStore.shared.restore()!
        let requestData = ReturnPointRequest(point: point)
        return self.provider.request(.transfer(userId: appUser.overview.id, bankAccountId: account.id, data: requestData))
            .filterError()
            .convertToJsonObservable()
            .map({ _ -> Void in
                
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}

