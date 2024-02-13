//
//  Messenger.swift
//
//  Created by QSD BiH on 4. 1. 2024..
//

import Foundation

/// - Tag: Messenger
protocol Messenger {

    ///   Performs a test operation and returns a result as a String.
    ///
    ///   The method is intended to simulate a test scenario and provide a String result based on the outcome of the test.
    ///
    /// - Returns: A String representing the result of the test operation.
    func test() -> String

    ///   Sets user information for the application.
    ///
    ///   This function updates or initializes the user information for the application.
    ///   The [User] object containing the user information.
    ///
    /// - Parameter user: The [User](x-source-tag://User) object containing the user information.
    ///
    func setUserInfo(user: User)
    
    ///   Sets a user JWT token that enables Messenger to treat this user as a logged-in user.
    ///
    /// - Parameter userJwt: The JSON Web Token (JWT) representing the user's authentication.
    ///
    /// - Returns: `true` if the token is successfully saved, `false` otherwise.
    func authorizeUser(userJwt: String) -> Bool

    ///   Logs out the current user from the SDK session.
    ///
    ///   This method performs a logout operation, ending the current user's session with the SDK. After calling this method, the user will need to log in again to use the SDK features.
    ///
    /// - Returns: `true` if the logout operation is successful; `false` otherwise.
    func forgetUser() -> Bool

    ///   Sets the push registration token for the current user.
    ///
    ///   This method associates the provided device token with the current user, enabling the SDK to send push notifications to the specified device.
    ///
    /// - Parameter token: The push registration token obtained from the device.
    ///
    /// - Returns: `true` if the push registration token is successfully set; `false` otherwise.
    func setPushRegistrationToken(token: String) -> Bool

    ///   Checks whether a push notification is related to the DeskPro SDK.
    ///
    ///   This method examines the provided push notification data to determine whether it is intended for the DeskPro SDK.
    ///
    /// - Parameter data: The push notification data to be analyzed.
    ///
    /// - Returns: `true` if the push notification is related to DeskPro; `false` otherwise.
    ///
    /// - Tag: isDeskProPushNotification
    func isDeskProPushNotification(data: [AnyHashable: Any]) -> Bool

    ///   Handles the incoming push notification data if it is related to DeskPro.
    ///
    ///   We recommend calling [isDeskProPushNotification](x-source-tag://isDeskProPushNotification) method before invoking this method to check if the push notification is related to DeskPro. If the check is successful, this method processes the provided push notification data and takes appropriate actions based on its content.
    ///
    ///   If the push notification is not related to DeskPro, it is advisable to handle it appropriately.
    ///
    /// - Parameter pushNotification: The push notification data to be handled.
    ///
    func handlePushNotification(pushNotification: PushNotificationData) -> Void

    ///   Provides a [PresentBuilder](x-source-tag://PresentBuilder) for constructing presentation paths within the application.
    ///
    ///   This function returns a [PresentBuilder](x-source-tag://PresentBuilder) instance, allowing the construction of presentation paths for various features within the application. The resulting paths can be used to navigate or present specific content.
    ///
    /// - Returns: A [PresentBuilder](x-source-tag://PresentBuilder) instance to start building presentation paths.
    ///
    func present() -> PresentBuilder

    ///   Closes the chat view presented by the DeskPro SDK.
    ///
    ///   This method closes the currently displayed chat view, terminating the user's interaction with the DeskPro content.
    ///
    func close() -> Void

    ///   Retrieves the number of unread conversations in the user's inbox.
    ///
    ///   This method returns the count of conversations marked as unread in the user's inbox.
    ///
    /// - Returns: The number of unread conversations in the inbox.
    ///
    func getUnreadConversationCount() -> Int

    ///   Enables logging for the DeskPro SDK.
    ///
    ///   This method turns on logging for the DeskPro SDK, allowing detailed information to be logged for debugging and troubleshooting purposes.
    ///
    func enableLogging() -> Void
}
