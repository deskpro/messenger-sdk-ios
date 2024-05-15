//
//  User.swift
//
//  Created by QSD BiH on 25. 1. 2024..
//

import Foundation

/// - Tag: User
@objc public class User: NSObject, Codable {
    
    @objc public var name: String? = nil
    @objc public var first_name: String? = nil
    @objc public var last_name: String? = nil
    @objc public var email: String? = nil
    
    @objc public init(name: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil) {
        self.name = name
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
    }
    
    /// Objective-C compatible equality check
    @objc public func isEqualToUser(_ user: User) -> Bool {
        return self.name == user.name && self.first_name == user.first_name && self.last_name == user.last_name && self.email == user.email
    }
}

/// Extend the Swift functionality to still support the == operator in Swift contexts
extension User {
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.isEqualToUser(rhs)
    }
}
