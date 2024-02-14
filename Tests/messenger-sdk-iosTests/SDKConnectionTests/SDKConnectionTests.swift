//
//  SDKConnectionTests.swift
//
//
//  Created by QSD BiH on 14. 2. 2024..
//

import XCTest
@testable import messenger_sdk_ios

final class SDKConnectionTests: XCTestCase {
    
    func testConnectionWithSDK() {
        XCTAssertEqual(DeskPro.test(), "Hello world from Messenger!", "❌The strings do not match.❌")
    }
}
