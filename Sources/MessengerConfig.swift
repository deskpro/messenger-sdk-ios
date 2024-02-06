//
//  MessengerConfig.swift
//  DeskproFramework
//
//  Created by QSD BiH on 4. 1. 2024..
//

import Foundation

///  Configuration data class for initializing the Messenger feature in the application.
///
///  This data class holds configuration parameters required for setting up and initializing the Messenger feature within the application. The configuration includes the base URL of the Messenger service, the application ID, and the application key.
public final class MessengerConfig {
    
    public var appUrl: String
    public var appId: String
    public var appKey: String?
    
    ///- Parameter appUrl: The base URL of the Messenger service.
    ///- Parameter appId: The unique identifier for the application using the Messenger feature.
    ///- Parameter appKey: The secret key for authenticating the application with the Messenger service.
    public init(appUrl: String, appId: String, appKey: String? = nil) {
        self.appUrl = appUrl
        self.appId = appId
        self.appKey = appKey
    }
}
