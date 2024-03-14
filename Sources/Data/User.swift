//
//  User.swift
//
//  Created by QSD BiH on 25. 1. 2024..
//

import Foundation

/// - Tag: User
public class User: Codable, Equatable {
    
    public var name: String? = nil
    public var first_name: String? = nil
    public var last_name: String? = nil
    public var email: String? = nil
    
    public init(name: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil) {
        self.name = name
        self.first_name = firstName
        self.last_name = lastName
        self.email = email
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.first_name == rhs.first_name && lhs.last_name == rhs.last_name && lhs.email == rhs.email
    }
}
