//
//  PushNotificationTests.swift
//
//
//  Created by QSD BiH on 14. 2. 2024..
//

import XCTest
@testable import messenger_sdk_ios

final class PushNotificationTests: XCTestCase {
  
    func testValidPushNotification() {
        let content = UNMutableNotificationContent()
        let userInfo = ["issuer" : "deskpro-messenger"]
        content.userInfo = userInfo as [AnyHashable : Any]
        
        XCTAssertTrue(DeskPro.isDeskProPushNotification(data: content.userInfo), ErrorMessages.invalidNotificationData)
    }
    
    func testInvalidPushNotification() {
        let content = UNMutableNotificationContent()
        let userInfo = ["issuer" : "some-messenger"]
        content.userInfo = userInfo as [AnyHashable : Any]
        
        XCTAssertFalse(DeskPro.isDeskProPushNotification(data: content.userInfo), ErrorMessages.validNotificationData)
    }
}
