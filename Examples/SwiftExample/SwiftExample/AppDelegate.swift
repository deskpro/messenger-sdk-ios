//
//  AppDelegate.swift
//  SwiftExample
//
//  Created by QSD BiH on 5. 1. 2024..
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import messenger_sdk_ios

protocol PushNotificationDelegate: AnyObject, MessagingDelegate {
    
    func didRegisterForRemoteNotifications(withDeviceToken token: String, type: TokenType)
}

enum TokenType: String {
    case apnsToken, fcmToken
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    weak var pushNotificationDelegate: PushNotificationDelegate?
    
    var messenger: DeskPro?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //print("token: \(token)")
        //pushNotificationDelegate?.didRegisterForRemoteNotifications(withDeviceToken: token, type: .apnsToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcm = Messaging.messaging().fcmToken {
            print("fcmToken: \(fcm)")
            pushNotificationDelegate?.didRegisterForRemoteNotifications(withDeviceToken: fcm, type: .fcmToken)
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //triggered when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        print(isValidNotification(userInfo: userInfo))
        return [[.alert, .sound]]
    }
    
    //triggered when notification is tapped
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print(isValidNotification(userInfo: userInfo))
    }
    
    //triggered sometimes, when app is in the background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if isValidNotification(userInfo: userInfo) {
            
            let center = UNUserNotificationCenter.current()
            var identifiers: [String] = []
            center.getDeliveredNotifications(completionHandler: { notifications in
                
                for notification in notifications {
                    identifiers.append(notification.request.identifier)
                }
                
                print("identifiers: \(identifiers.count)")
                if identifiers.count > 1 {
                    print(identifiers)
                    identifiers.removeFirst()
                    print(identifiers)
                    center.removeDeliveredNotifications(withIdentifiers: identifiers)
                }
                
                completionHandler(.newData)
            })
        }
    }
    
    func isValidNotification(userInfo: [AnyHashable: Any]) -> Bool {
        return DeskPro.isDeskProPushNotification(data: userInfo)
    }
}
