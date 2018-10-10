//
//  AppUserRepository.swift
//  pochi
//
//  Created by akiho on 2017/03/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya
import Firebase
import FBSDKLoginKit

class AppUserRepository: ProvideTokenProtocol {
    static let shared = AppUserRepository()
    
    private var provider: RxMoyaProvider<UserApi> {
        return RxMoyaProvider<UserApi>(plugins: [authPlugin])
    }
    
    private var fireTokenByFb: AppUser.FireAuth?
    
    private init() {
        
    }
    
    func me() -> Observable<User> {
        return provider.request(.fetch(id: AppUserStore.shared.restore()!.overview.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> User in
                return UserResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func authenticate(data: SignInFormData.SendData) -> Observable<AppUser> {
        return self.fireAuthenticate(data: data)
            .flatMap({ fireAuth -> Observable<AppUser> in
                return self.provider.request(.authenticate)
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> UserResponse in
                        return UserResponse.from(json: json)
                    })
                    .map({ response in
                        return response.to(fireAuth: fireAuth)
                    })
                    .do(onNext: { appUser in
                        AppUserStore.shared.store(user: appUser)
                        AppUserStore.shared.store(provider: .email)
                    })
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            })
    }
    
    func authenticate(fbToken: String) -> Observable<AppUser> {
        return self.fireAuthenticate(fbToken: fbToken)
            .flatMap({ fireAuth -> Observable<AppUser> in
                return self.provider.request(.authenticate)
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> UserResponse in
                        return UserResponse.from(json: json)
                    })
                    .map({ response in
                        return response.to(fireAuth: fireAuth)
                    })
                    .do(onNext: { appUser in
                        AppUserStore.shared.store(user: appUser)
                        AppUserStore.shared.store(provider: .facebook)
                    }, onError: { _ in
                        self.deleteFBUser()
                    })
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            })
    }
    
    func create(fbToken: String) -> Observable<AppUser.FireAuth> {
        return self.fireAuthenticate(fbToken: fbToken)
            .do(onNext: { token in
                self.fireTokenByFb = token
            })
            .asObservable()
    }
    
    func create(data: SignUpFormData.SendData) -> Observable<AppUser> {
        if let fireToken = fireTokenByFb {
            return Observable.just(fireToken)
                .flatMap({ fireAuth -> Observable<AppUser> in
                    let requestData = CreateUserRequest(
                        firstName: data.firstName,
                        lastName: data.lastName,
                        nickName: data.nickName)
                    
                    return self.provider.request(.create(data: requestData))
                        .filterError()
                        .retryIfError()
                        .convertToJsonObservable()
                        .map({ json -> UserResponse in
                            return UserResponse.from(json: json)
                        })
                        .map({ response in
                            return response.to(fireAuth: fireAuth)
                        })
                        .do(onNext: { appUser in
                            AppUserStore.shared.store(user: appUser)
                            AppUserStore.shared.store(provider: .facebook)
                        })
                        .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
                })
        } else {
            return self.fireAuthenticate(data: data)
                .flatMap({ fireAuth -> Observable<AppUser> in
                    let requestData = CreateUserRequest(
                        firstName: data.firstName,
                        lastName: data.lastName,
                        nickName: data.nickName)
                    
                    return self.provider.request(.create(data: requestData))
                        .filterError()
                        .retryIfError()
                        .convertToJsonObservable()
                        .map({ json -> UserResponse in
                            return UserResponse.from(json: json)
                        })
                        .map({ response in
                            return response.to(fireAuth: fireAuth)
                        })
                        .do(onNext: { appUser in
                            AppUserStore.shared.store(user: appUser)
                            AppUserStore.shared.store(provider: .email)
                        })
                        .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
                })
        }
    }
    
    func update(data: EditProfileData.SendData) -> Observable<AppUser> {
        let appUser: AppUser = AppUserStore.shared.restore()!
        let requestData = UpdateUserRequest(nickName: data.nickName,
                                            introductionMessage: data.introductionMessage,
                                            imageData: data.imageData.isEmpty ? nil : data.imageData)
        return provider.request(.update(id: appUser.overview.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> AppUser in
                let user: User = UserResponse.from(json: json).to()
                return appUser.updateUser(user: user)
            })
            .do(onNext: { appUser in
                AppUserStore.shared.store(user: appUser)
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func updateIcon(image: UIImage) -> Observable<AppUser> {
        let appUser: AppUser = AppUserStore.shared.restore()!
        return provider.request(.fetchUploadImageUrl(id: appUser.overview.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> String in
                return UploadImageUrlResponse.from(json: json).url
            })
            .flatMap({ url -> Observable<AppUser> in
                let uploadData = UploadImageRequest(image: image, format: .jpeg)
                return self.provider.request(.uploadImage(url: url, data: uploadData))
                    .filterError()
                    .convertToJsonObservable()
                    .map({ json -> AppUser in
                        let user: User = UserResponse.from(json: json).to()
                        return appUser.updateUser(user: user)
                    })
                    .do(onNext: { appUser in
                        AppUserStore.shared.store(user: appUser)
                    })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func updateEmail(appUser: AppUser, data: EditEmailData.SendData) -> Observable<AppUser> {
        let subject = PublishSubject<AppUser>()
        
        Auth.auth().currentUser?.updateEmail(to: data.email, completion: { error -> Void in
            guard error == nil else {
                subject.onError(error!)
                return
            }
            
            let newUser = appUser.updateEmail(newEmail: data.email)
            
            subject.onNext(newUser)
            AppUserStore.shared.store(user: newUser)
        })
        
        return subject
    }
    
    func updatePassword(appUser: AppUser, data: EditPasswordData.SendData) -> Observable<Void> {
        let credential = EmailAuthProvider.credential(withEmail: appUser.email, password: data.password)
        let subject = PublishSubject<Void>()
        let authUser = Auth.auth().currentUser
        
        authUser?.reauthenticate(with: credential, completion: { error in
            guard error == nil else {
                subject.onError(error!)
                return
            }
            
            authUser?.updatePassword(to: data.newPassword, completion: { error -> Void in
                guard error == nil else {
                    subject.onError(error!)
                    return
                }
                
                subject.onNext()
            })
        })
        
        return subject
    }
    
    func sendPasswordForReset(data: ResetPasswordData.SendData) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        Auth.auth().sendPasswordReset(withEmail: data.email, completion: { error in
            guard error == nil else {
                subject.onError(error!)
                return
            }
            
            subject.onNext()
        })
        
        return subject
    }
    
    func deleteFBUser() {
        Auth.auth().currentUser?.delete(completion: nil)
        self.signOut()
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        AppUserStore.shared.clear()
        TokenStore.shared.clear()
        FBSDKLoginManager().logOut()
    }
    
    func refreshFireToken() {
        Auth.auth().currentUser?.getTokenForcingRefresh(true, completion: { token, error in
            guard let token = token else {
                return
            }
            
            TokenStore.shared.storeFireToken(token: token)
        })
    }
    
    private func fireAuthenticate(data: SignInFormData.SendData) -> PublishSubject<AppUser.FireAuth> {
        let subject = PublishSubject<AppUser.FireAuth>()
        
        Auth.auth().signIn(withEmail: data.email, password: data.password, completion: { user, error in
            guard let user = user else {
                subject.onError(error!)
                return
            }
            
            user.getToken(completion: { token, error in
                guard let token = token else {
                    subject.onError(error!)
                    return
                }
                
                TokenStore.shared.storeFireToken(token: token)
                subject.onNext(AppUser.FireAuth(uid: user.uid, email: user.email!, token: token))
            })
        })
        
        return subject
    }
    
    private func fireAuthenticate(data: SignUpFormData.SendData) -> PublishSubject<AppUser.FireAuth> {
        let subject = PublishSubject<AppUser.FireAuth>()
        
        Auth.auth().createUser(withEmail: data.email, password: data.password, completion: { user, error in
            guard let user = user else {
                subject.onError(error!)
                return
            }
            
            user.getToken(completion: { token, error in
                guard let token = token else {
                    subject.onError(error!)
                    return
                }
                
                TokenStore.shared.storeFireToken(token: token)
                subject.onNext(AppUser.FireAuth(uid: user.uid, email: user.email!, token: token))
            })
        })
        
        return subject
    }
    
    private func fireAuthenticate(fbToken: String) -> PublishSubject<AppUser.FireAuth> {
        let subject = PublishSubject<AppUser.FireAuth>()
        
        let credential = FacebookAuthProvider.credential(withAccessToken: fbToken)
        Auth.auth().signIn(with: credential, completion: { user, error in
            guard let user = user else {
                subject.onError(error!)
                return
            }
            
            user.getToken(completion: { token, error in
                guard let token = token else {
                    subject.onError(error!)
                    return
                }
                
                TokenStore.shared.storeFireToken(token: token)
                subject.onNext(AppUser.FireAuth(uid: user.uid, email: user.email!, token: token))
            })
        })
        
        return subject
    }

}
