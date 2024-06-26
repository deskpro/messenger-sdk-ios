//
//  Deskpro.swift
//
//  Created by QSD BiH on 4. 1. 2024..
//

import UIKit

///  Implementation of the [Messenger](x-source-tag://Messenger) protocol for interacting with DeskPro messaging functionality.
///
///  The `DeskPro` class provides methods for initializing the Messenger, managing user information,
///  handling push notifications, and presenting the DeskPro messaging interface.
///
@objc public final class DeskPro: NSObject, Messenger {
    
    private var messengerConfig: MessengerConfig
    
    ///  Coordinator to make sure that only one instance of webView is opened.
    private var coordinator: PresentCoordinator
    
    ///  User defaults manager for storing user-related information.
    var appUserDefaults: DeskproUserDefaults
    
    ///  Each Deskpro instance is having its own eventRouter to handle events in chat.
    @objc public var eventRouter: EventRouter
    
    ///  Initializes the functionality of the application.
    ///
    ///  This method is a constructor for creating Deskpro objects with specific configurations and prepare for the execution of other features.
    ///
    ///- Parameter messengerConfig: The configuration object containing settings for the DeskPro Messenger.
    ///
    @objc public init(messengerConfig: MessengerConfig, containingViewController: UIViewController, enableAutologging: Bool = false) {
        self.eventRouter = .init(enableAutologging: enableAutologging)
        self.messengerConfig = messengerConfig
        self.coordinator = PresentCoordinator(containingViewController: containingViewController, eventRouter: eventRouter)
        self.appUserDefaults = DeskproUserDefaults(appId: messengerConfig.appId)
    }
    
    ///   Performs a test operation and returns a result as a String.
    ///
    ///   The method is intended to simulate a test scenario and provide a String result based on the outcome of the test.
    ///
    /// - Returns: A String representing the result of the test operation.
    @objc public static func test() -> String {
        return "Hello world from Messenger!"
    }
    
    ///   Sets user information for the application.
    ///
    ///   This function updates or initializes the user information for the application.
    ///   The [User] object containing the user information.
    ///
    /// - Parameter user: The [User](x-source-tag://User) object containing the user information.
    ///
    @objc public final func setUserInfo(user: User) {
        appUserDefaults.setUserInfo(user)
    }
    
    ///   Getter method for user info, should only be used for testing.
    final func getUserInfo() -> User? {
        return appUserDefaults.getUserInfo()
    }
    
    ///   Getter method for user info in JSON format, should only be used for testing.
    final func getUserInfoJson() -> String? {
        return appUserDefaults.getUserInfoJson()
    }
    
    ///   Sets a user JWT token that enables Messenger to treat this user as a logged-in user.
    ///
    /// - Parameter userJwt: The JSON Web Token (JWT) representing the user's authentication.
    ///
    /// - Returns: `true` if the token is successfully saved, `false` otherwise.
    @discardableResult
    @objc public final func authorizeUser(userJwt: String) -> Bool {
        appUserDefaults.setJwtToken(userJwt)
        return true
    }
    
    ///   Getter method for JWT token, should only be used for testing.
    func getJwtToken() -> String? {
        return appUserDefaults.getJwtToken()
    }
    
    ///   Logs out the current user from the SDK session.
    ///
    ///   This method performs a logout operation, ending the current user's session with the SDK. After calling this method, the user will need to log in again to use the SDK features.
    ///
    /// - Returns: `true` if the logout operation is successful; `false` otherwise.
    @discardableResult
    @objc public final func forgetUser() -> Bool {
        appUserDefaults.clear()
        return true
    }
    
    ///   Sets the push registration token for the current user.
    ///
    ///   This method associates the provided device token with the current user, enabling the SDK to send push notifications to the specified device.
    ///
    /// - Parameter token: The push registration token obtained from the device.
    ///
    /// - Returns: `true` if the push registration token is successfully set; `false` otherwise.
    @discardableResult
    @objc public final func setPushRegistrationToken(token: String) -> Bool {
        appUserDefaults.setDeviceToken(token)
        return true
    }
    
    ///   Getter method for device token, should only be used for testing.
    func getPushRegistrationToken() -> String? {
        return appUserDefaults.getDeviceToken()
    }
    
    ///   Checks whether a push notification is related to the DeskPro SDK.
    ///
    ///   This method examines the provided push notification data to determine whether it is intended for the DeskPro SDK.
    ///
    /// - Parameter data: The push notification data to be analyzed.
    ///
    /// - Returns: `true` if the push notification is related to DeskPro; `false` otherwise.
    ///
    /// - Tag: isDeskProPushNotification
    @objc public static func isDeskProPushNotification(data: [AnyHashable: Any]) -> Bool {
        if let issuer = data["issuer"] as? String {
            return issuer == "deskpro-messenger"
        } else {
            return false
        }
    }
    
    ///   Handles the incoming push notification data if it is related to DeskPro.
    ///
    ///   We recommend calling [isDeskProPushNotification](x-source-tag://isDeskProPushNotification) method before invoking this method to check if the push notification is related to DeskPro. If the check is successful, this method processes the provided push notification data and takes appropriate actions based on its content.
    ///
    ///   If the push notification is not related to DeskPro, it is advisable to handle it appropriately.
    ///
    /// - Parameter pushNotification: The push notification data to be handled.
    ///
    @objc public final func handlePushNotification(pushNotification: PushNotificationData) {
        // TODO: Not yet implemented
    }
    
    ///   Provides a [PresentBuilder](x-source-tag://PresentBuilder) for constructing presentation paths within the application.
    ///
    ///   This function returns a [PresentBuilder](x-source-tag://PresentBuilder) instance, allowing the construction of presentation paths for various features within the application. The resulting paths can be used to navigate or present specific content.
    ///
    /// - Returns: A [PresentBuilder](x-source-tag://PresentBuilder) instance to start building presentation paths.
    ///
    @objc public final func present() -> PresentBuilder {
        let url = buildUrl(baseUrl: messengerConfig.appUrl, appId: messengerConfig.appId)
        return PresentBuilder(url: url ?? "", appId: messengerConfig.appId, coordinator: coordinator)
    }
    
    func buildUrl(baseUrl: String, appId: String) -> String? {
        let platformData = ["platform": "IOS"]
        
        guard let platformJsonData = try? JSONSerialization.data(withJSONObject: platformData, options: []),
              let platformJsonString = String(data: platformJsonData, encoding: .utf8),
              let encodedPlatform = platformJsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        let formattedBaseUrl = baseUrl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let formattedAppId = "/" + appId.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        return "\(formattedBaseUrl)\(formattedAppId)/\(encodedPlatform)"
    }
    
    ///   Closes the chat view presented by the DeskPro SDK.
    ///
    ///   This method closes the currently displayed chat view, terminating the user's interaction with the DeskPro content.
    ///
    @objc public final func close() {
        // TODO: Not yet implemented
    }
    
    ///   Retrieves the number of unread conversations in the user's inbox.
    ///
    ///   This method returns the count of conversations marked as unread in the user's inbox.
    ///
    /// - Returns: The number of unread conversations in the inbox.
    ///
    @objc public final func getUnreadConversationCount() -> Int {
        // TODO: Not yet implemented
        return 0
    }
    
    ///   Enables logging for the DeskPro SDK.
    ///
    ///   This method turns on logging for the DeskPro SDK, allowing detailed information to be logged for debugging and troubleshooting purposes.
    ///
    @objc public final func enableLogging() {
        // TODO: Not yet implemented
    }
}

