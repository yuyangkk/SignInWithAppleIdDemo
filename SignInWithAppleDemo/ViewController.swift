//
//  ViewController.swift
//  SignInWithAppleDemo
//
//  Created by Kaye on 2019/12/23.
//  Copyright © 2019 Kaye. All rights reserved.
//

import UIKit
import AuthenticationServices
import SwiftJWT

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let stack = UIStackView(frame: CGRect(origin: CGPoint(x: 0, y: 100), size: CGSize(width: view.bounds.size.width, height: view.bounds.size.height-100-250)))
        stack.backgroundColor = UIColor.purple
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.distribution = .fillEqually
        view.addSubview(stack)
        
        let signInButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        signInButton.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton)
        
        let signInButton1 = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        signInButton1.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton1)
        
        let signInButton2 = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        signInButton2.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton2)
        
        let signInButton3 = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
        signInButton3.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton3)
        
        let signInButton4 = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .black)
        signInButton4.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton4)
        
        let signInButton5 = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .whiteOutline)
        signInButton5.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton5)
        
        let signInButton6 = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .white)
        signInButton6.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton6)
        
        let signInButton7 = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .black)
        signInButton7.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton7)
        
        let signInButton8 = ASAuthorizationAppleIDButton(authorizationButtonType: .continue, authorizationButtonStyle: .whiteOutline )
        signInButton8.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
        stack.addArrangedSubview(signInButton8)
    }


    @objc func signInWithApple() {
        let idRequest = ASAuthorizationAppleIDProvider().createRequest()
        idRequest.requestedScopes = [.fullName, .email]

        //用户可能已经在您的系统中拥有一个帐户，但是可能尝试使用“使用Apple登录”登录该帐户。 共享与用户的Apple ID相关联的真实电子邮件地址可能无济于事，因为它可能与用于在您的系统上创建帐户的电子邮件地址不同。 有两种方法可以缓解此问题：
        //实现ASAuthorizationPasswordProvider类以检测并提供系统已经知道的钥匙串凭据。 这可以无缝地检测和使用现有帐户，并防止使用“使用Apple登录”来创建新帐户。
        //对于使用“使用Apple登录”创建的新帐户，让用户知道他们已经创建了一个新帐户，并询问他们是否有任何现有帐户要链接。
//        let passwordRequest = ASAuthorizationPasswordProvider().createRequest()
        
        let array = [idRequest]
        
        let controller = ASAuthorizationController(authorizationRequests: array)
        controller.delegate = self;
        controller.presentationContextProvider = self;
        controller.performRequests()
    }
    
    func handleAppleResponse(credential:ASAuthorizationAppleIDCredential) {
        if let state = credential.state {
            print("state:\(state)")
        }
        
        let user = credential.user
        print("user:\(user)")
        
        
        if let fullName = credential.fullName {
            print("funllName:\(String(describing: fullName))")
        }
        
        
        if let email = credential.email {
            print("email:\(email)")
        }
        
        if let authorizationCode = String(data: credential.authorizationCode!, encoding: .utf8) {
            print("authrizationCode:\(authorizationCode)")
        }
        
        if let identityToken = String(data: credential.identityToken!, encoding: .utf8) {
            print("identityToken:\(identityToken)")
            
            let publicKeyString = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlxrwmuYSAsTfn+lUu4go
ZSXBD9ackM9OJuwUVQHmbZo6GW4Fu/auUdN5zI7Y1dEDfgt7m7QXWbHuMD01HLnD
4eRtY+RNwCWdjNfEaY/esUPY3OVMrNDI15Ns13xspWS3q+13kdGv9jHI28P87RvM
pjz/JCpQ5IM44oSyRnYtVJO+320SB8E2Bw92pmrenbp67KRUzTEVfGU4+obP5RZ0
9OxvCr1io4KJvEOjDJuuoClF66AT72WymtoMdwzUmhINjR0XSqK6H0MdWsjw7ysy
d/JhmqX5CAaT9Pgi0J8lU/pcl215oANqjy7Ob+VMhug9eGyxAWVfu/1u6QJKePlE
+wIDAQAB
-----END PUBLIC KEY-----
"""
            
            if let data = publicKeyString.data(using: .utf8) {
                // 模拟验签
                let jwtVerifier = JWTVerifier.rs256(publicKey: data)
                let verified = JWT<MyClaims>.verify(identityToken, using: jwtVerifier)
                print("验签结果是：\(verified)")
            }
        }
        let realUserStatus = credential.realUserStatus
        print("realUserStatus:\(realUserStatus)")
    }
}

struct MyClaims: Claims {
    var iss:String?
    var aud:String?
    var sub:String?
    var c_hash:String?
}

extension ViewController: ASAuthorizationControllerDelegate {
    
    // 成功回调
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleResponse(credential: credential)
        }
        
        if let credential = authorization.credential as? ASPasswordCredential {
            print("user:\(credential.user) password:\(credential.password)")
        }
    }
    
    // 失败回调
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        var errorMsg = ""
        switch error as! ASAuthorizationError {
        case ASAuthorizationError.canceled:
            errorMsg = "用户取消了授权请求"
        case ASAuthorizationError.failed:
            errorMsg = "授权请求失败"
        case ASAuthorizationError.invalidResponse:
            errorMsg = "授权请求响应无效"
        case ASAuthorizationError.notHandled:
            errorMsg = "未能处理授权请求"
        case ASAuthorizationError.unknown:
            errorMsg = "授权请求失败未知原因"
        default:
            errorMsg = "未知错误"
        }
        print("苹果授权失败：" + errorMsg)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

