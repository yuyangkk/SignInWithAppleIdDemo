//
//  AppDelegate.swift
//  SignInWithAppleDemo
//
//  Created by Kaye on 2019/12/23.
//  Copyright © 2019 Kaye. All rights reserved.
//

import UIKit
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 查询授权状态
        // 苹果说这个接口很快
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: "当前用户的唯一标识，也就是授权成功后返回的user") { (credentialState, error) in
            switch(credentialState){
            case .authorized:
                print("Apple ID Credential is valid")
            case .revoked:
                print("Apple ID Credential revoked, handle unlink")
            case .notFound:
                print("Credential not found, show login UI")
            default:
                break
            }
        }
        
        // 监听用户是否解绑AppleID
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: OperationQueue.main) { (notification) in
            // App生命周期存续期间，以下变动会收到该通知
            // 1.退出登录AppleId后返回到App
            // 2.授权成功会调用
            // 3.在设置中取消用户授权后返回到App
            print("用户登出Apple ID")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

