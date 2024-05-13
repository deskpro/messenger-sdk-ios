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
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.first_name == rhs.first_name && lhs.last_name == rhs.last_name && lhs.email == rhs.email
    }
}
