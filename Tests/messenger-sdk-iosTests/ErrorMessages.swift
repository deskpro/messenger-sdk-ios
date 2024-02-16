//
//  ErrorMessages.swift
//  
//
//  Created by QSD BiH on 16. 2. 2024..
//

import Foundation

struct ErrorMessages {
    
    static var usersNotMatching = formatMessage("The users do not match.")
    static var tokensNotMatching = formatMessage("The tokens do not match.")
    static var pathsNotMatching = formatMessage("The paths do not match.")
    static var stringsNotMatching = formatMessage("The strings do not match.")
    static var userInfoNotNil = formatMessage("The user info is not nil.")
    static var userInfoJsonNotNil = formatMessage("The user info Json is not nil.")
    static var jwtTokenNotNil = formatMessage("The jwt token is not nil.")
    static var deviceTokenNotNil = formatMessage("The device token is not nil.")
    static var validNotificationData = formatMessage("The notification is valid.")
    static var invalidNotificationData = formatMessage("The notification is not valid.")
    
    private static func formatMessage(_ message: String) -> String {
        return "❌\(message)❌"
    }
}
