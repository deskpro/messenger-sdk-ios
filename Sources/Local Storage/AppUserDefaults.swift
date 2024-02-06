//
//  AppUserDefaults.swift
//  DeskproFramework
//
//  Created by QSD BiH on 25. 1. 2024..
//

import Foundation

///UserDefaults utility class for managing user information and JWT tokens in the DeskPro Messenger module.
///
///The class provides methods for retrieving, storing, and clearing user information and JWT tokens using the UserDefaults API.
class AppUserDefaults {

    ///UserDefaults instance.
    let prefs = UserDefaults.standard
    
    ///The application ID associated with the DeskPro Messenger module.
    private let appId: String
    
    ///Key for storing user information in UserDefaults.
    private var userInfoKey: String { "\(appId)_user_info" }
    
    ///Key for storing JWT token in UserDefaults.
    private var jwtTokenKey: String { "\(appId)_jwt_token" }

    init(appId: String) {
        self.appId = appId
    }

    ///   Retrieves the user information from UserDefaults.
    ///
    /// - Returns: The [User](x-source-tag://User) object representing user information, or nil if not present.
    func getUserInfo() -> User? {
        guard let data = prefs.data(forKey: userInfoKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    ///   Retrieves the user information JSON string from UserDefaults.
    ///
    /// - Returns: The user information JSON string, or nil if not present.
    func getUserInfoJson() -> String? {
        guard let data = prefs.data(forKey: userInfoKey),
              let user = try? JSONDecoder().decode(User.self, from: data),
              let jsonData = try? JSONEncoder().encode(user) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

    ///   Retrieves the JWT token from UserDefaults.
    ///
    /// - Returns: The JWT token, or nil if not present.
    func getJwtToken() -> String? {
        return prefs.string(forKey: jwtTokenKey)
    }

    ///   Sets the user information in UserDefaults.
    ///
    ///   If the user is nil, removes the user information from UserDefaults.
    ///
    /// - Parameter user: The [User](x-source-tag://User) object representing user information, or nil.
    ///
    func setUserInfo(_ user: User?) {
        guard let data = try? JSONEncoder().encode(user) else { prefs.removeObject(forKey: userInfoKey); return }
        prefs.set(data, forKey: userInfoKey)
    }

    ///   Sets the JWT token in UserDefaults.
    ///
    ///   If the token is nil, removes the token from UserDefaults.
    ///
    /// - Parameter user: The [User](x-source-tag://User) object representing user information, or nil.
    ///
    func setJwtToken(_ token: String?) {
        guard let token else { prefs.removeObject(forKey: jwtTokenKey); return }
        prefs.set(token, forKey: jwtTokenKey)
    }

    ///   Clears all data from UserDefaults.
    func clear() {
        UserDefaults.standard.removeObject(forKey: userInfoKey)
        UserDefaults.standard.removeObject(forKey: jwtTokenKey)
    }
}
