//
//  AppUserDefaultsTests.swift
//  
//
//  Created by QSD BiH on 14. 2. 2024..
//

import XCTest
@testable import messenger_sdk_ios

final class AppUserDefaultsTests: XCTestCase {

    var messenger: DeskPro?
    var appUserDefaults: AppUserDefaults?
    let appUrl = "https://dev-pr-12927.earthly.deskprodemo.com/deskpro-messenger/deskpro/1/d"
    let appId = "1"
    let vc = UIViewController()
    
    let user = User(firstName: "John", lastName: "Doe")
    let jwtToken = "some-jwt-token"
    let deviceToken = "some-device-token"
    
    override func setUp() {
        let messengerConfig = MessengerConfig(appUrl: appUrl, appId: appId)
        messenger = DeskPro(messengerConfig: messengerConfig, containingViewController: vc)
        appUserDefaults = AppUserDefaults(appId: appId)
    }
    
    override func tearDown() {
        messenger = nil
        appUserDefaults?.clear()
        appUserDefaults = nil
    }
    
    func testUserInfo() {
        messenger?.setUserInfo(user: user)
        
        XCTAssertEqual(user, appUserDefaults?.getUserInfo(), "❌The users do not match.❌")
    }
    
    func testUserInfoJson() {
        messenger?.setUserInfo(user: user)
        
        if let jsonString = appUserDefaults?.getUserInfoJson(),
           let jsonData = jsonString.data(using: .utf8) {
            let savedUser = try? JSONDecoder().decode(User.self, from: jsonData)
            XCTAssertEqual(user, savedUser, "❌The users do not match.❌")
        }
    }
    
    func testJwtToken() {
        messenger?.authorizeUser(userJwt: jwtToken)
        
        XCTAssertEqual(jwtToken, appUserDefaults?.getJwtToken(), "❌The tokens do not match.❌")
    }
    
    func testPushRegistrationToken() {
        messenger?.setPushRegistrationToken(token: deviceToken)
        
        XCTAssertEqual(deviceToken, appUserDefaults?.getDeviceToken(), "❌The tokens do not match.❌")
    }
    
    func testClearData() {
        messenger?.setUserInfo(user: user)
        messenger?.authorizeUser(userJwt: jwtToken)
        messenger?.setPushRegistrationToken(token: deviceToken)
        
        appUserDefaults?.clear()
        
        XCTAssertNil(appUserDefaults?.getUserInfoJson(), "❌The user info is not nil.❌")
        XCTAssertNil(appUserDefaults?.getJwtToken(), "❌The jwt token is not nil.❌")
        XCTAssertNil(appUserDefaults?.getDeviceToken(), "❌The device token is not nil.❌")
    }
}
