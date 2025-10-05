//
//  DeskproSetupTest.swift
//
//
//  Created by QSD BiH on 14. 2. 2024..
//

import XCTest
@testable import messenger_sdk_ios

final class DeskproSetupTest: XCTestCase {
    
    var messenger: DeskPro!
    let appUrl = "test/url/data"
    let appId = "1"
    let vc = UIViewController()
    
    let user = User(name: "John Doe", firstName: "John", lastName: "Doe", email: "john.doe@email.com")
    let jwtToken = "some-jwt-token"
    let deviceToken = "some-device-token"
    
    override func setUp() {
        let messengerConfig = MessengerConfig(appUrl: appUrl, appId: appId)
        messenger = DeskPro(messengerConfig: messengerConfig, containingViewController: vc)
    }
    
    override func tearDown() {
        messenger = nil
    }
    
    func testSetAndGetUserInfo() {
        messenger.setUserInfo(user: user)
        
        guard let savedUser = messenger.getUserInfo() else {
            XCTFail(ErrorMessages.userNotSavedLocally)
            return
        }
        
        XCTAssertTrue(user.isEqualToUser(savedUser), ErrorMessages.usersNotMatching)
    }

    func testSetAndGetUserInfoJson() {
        messenger.setUserInfo(user: user)
        
        guard let jsonString = messenger.getUserInfoJson(),
              let jsonData = jsonString.data(using: .utf8),
              let savedUser = try? JSONDecoder().decode(User.self, from: jsonData) else {
            XCTFail(ErrorMessages.userNotRetrievedOrDecoded)
            return
        }
        
        XCTAssertTrue(user.isEqualToUser(savedUser), ErrorMessages.usersNotMatching)
    }
    
    func testSetAndGetJwtToken() {
        messenger.authorizeUser(userJwt: jwtToken)
        
        XCTAssertEqual(jwtToken, messenger.getJwtToken(), ErrorMessages.tokensNotMatching)
    }
    
    func testSetAndGetPushRegistrationToken() {
        messenger.setPushRegistrationToken(token: deviceToken)
        
        XCTAssertEqual(deviceToken, messenger.getPushRegistrationToken(), ErrorMessages.tokensNotMatching)
    }
    
    func testClearData() {
        messenger.setUserInfo(user: user)
        messenger.authorizeUser(userJwt: jwtToken)
        messenger.setPushRegistrationToken(token: deviceToken)
        
        messenger.forgetUser()
        
        XCTAssertNil(messenger.getUserInfo(), ErrorMessages.userInfoNotNil)
        XCTAssertNil(messenger.getUserInfoJson(), ErrorMessages.userInfoJsonNotNil)
        XCTAssertNil(messenger.getJwtToken(), ErrorMessages.jwtTokenNotNil)
        XCTAssertNil(messenger.getPushRegistrationToken(), ErrorMessages.deviceTokenNotNil)
    }
    
    func testSetAndGetMultipleDeskProInstances() {
        let messengerConfig2 = MessengerConfig(appUrl: "some_url", appId: "2")
        let messenger2 = DeskPro(messengerConfig: messengerConfig2, containingViewController: vc)
        let user2 = User(name: "John Doe 2", firstName: "John 2", lastName: "Doe 2", email: "john.doe2@email.com")
        let jwtToken2 = "another-jwt-token"
        let deviceToken2 = "another-device-token"
        
        messenger.setUserInfo(user: user)
        messenger.authorizeUser(userJwt: jwtToken)
        messenger.setPushRegistrationToken(token: deviceToken)
        
        messenger2.setUserInfo(user: user2)
        messenger2.authorizeUser(userJwt: jwtToken2)
        messenger2.setPushRegistrationToken(token: deviceToken2)
        
        guard let savedUser = messenger.getUserInfo() else {
            XCTFail(ErrorMessages.userNotSavedLocally)
            return
        }
        
        XCTAssertTrue(user.isEqualToUser(savedUser), ErrorMessages.usersNotMatching)
        guard let jsonString = messenger.getUserInfoJson(),
              let jsonData = jsonString.data(using: .utf8),
              let savedUser = try? JSONDecoder().decode(User.self, from: jsonData) else {
            XCTFail(ErrorMessages.userNotRetrievedOrDecoded)
            return
        }
        XCTAssertTrue(user.isEqualToUser(savedUser), ErrorMessages.usersNotMatching)
        
        XCTAssertEqual(jwtToken2, messenger2.getJwtToken(), ErrorMessages.tokensNotMatching)
        XCTAssertEqual(deviceToken2, messenger2.getPushRegistrationToken(), ErrorMessages.tokensNotMatching)
    }
    
    func testPresentBuilder() {
        let presentBuilder = PresentBuilder(url: appUrl, appId: appId, coordinator: PresentCoordinator(containingViewController: vc, eventRouter: EventRouter()))
        XCTAssertEqual(appUrl, presentBuilder.getPath(), ErrorMessages.pathsNotMatching)
        
        _ = presentBuilder.chatHistory(1)
        XCTAssertEqual("\(appUrl)/chat_history/1", presentBuilder.getPath(), ErrorMessages.pathsNotMatching)
        
        _ = presentBuilder.article(1)
        XCTAssertEqual("\(appUrl)/chat_history/1/article/1", presentBuilder.getPath(), ErrorMessages.pathsNotMatching)
        
        _ = presentBuilder.comments()
        XCTAssertEqual("\(appUrl)/chat_history/1/article/1/comments", presentBuilder.getPath(), ErrorMessages.pathsNotMatching)
    }
}
