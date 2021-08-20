//
//  AuthService.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 14.08.2021.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: AnyObject {
    func authServiceShouldShow(_ viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInFail()
}

class AuthService: NSObject {
    
    private let appId = "7926640"
    private let vkSDK: VKSdk
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }
    
    var userId: String? {
        return VKSdk.accessToken().userId
    }
    
    static let shared = AuthService()
    
    override init() {
        vkSDK = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSDK.register(self)
        vkSDK.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["friends,wall,offline"]
        VKSdk.wakeUpSession(scope) { [delegate] state, error in
            switch state {

            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)

            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()

            @unknown default:
                delegate?.authServiceSignInFail()
            }
        }
    }
    
}

extension AuthService: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInFail()

    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(controller)

    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)

    }
    
    
}
