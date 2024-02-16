//
//  User.swift
//
//  Created by QSD BiH on 25. 1. 2024..
//

import Foundation

/// - Tag: User
public class User: Codable, Equatable {
    
    public var name: String? = nil
    public var firstName: String? = nil
    public var lastName: String? = nil
    public var email: String? = nil
    
    public init(name: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil) {
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.email == rhs.email
    }
}
