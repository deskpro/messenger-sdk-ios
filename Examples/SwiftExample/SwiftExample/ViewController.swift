//
//  ViewController.swift
//  SwiftExample
//
//  Created by QSD BiH on 5. 1. 2024..
//

import UIKit
import messenger_sdk_ios

class ViewController: UIViewController {
    
    @IBOutlet weak var appUrlTextfield: UITextField!
    @IBOutlet weak var appIdTextfield: UITextField!
    @IBOutlet weak var jwtTextview: UITextView!
    @IBOutlet weak var userinfoTextview: UITextView!
    @IBOutlet weak var appUrlUpdateBtn: UIButton!
    @IBOutlet weak var appIdUpdateBtn: UIButton!
    @IBOutlet weak var setJwtButon: UIButton!
    @IBOutlet weak var setUserinfoBtn: UIButton!
    @IBOutlet weak var enableNotificationsBtn: UIButton!
    @IBOutlet weak var openMessengetBtn: UIButton!
    @IBOutlet weak var clearCookiesBtn: UIButton!
    @IBOutlet weak var eventLogTextView: UITextView!
    @IBOutlet weak var copyTokenBtn: UIButton!
    @IBOutlet weak var copyLogsBtn: UIButton!
    
    var messenger: DeskPro?
    
    var appUrl = "https://master.earthly.deskprodemo.com/deskpro-messenger/00000000-0000-0000-0000-000000000000"
    var appId = "/0000000000HXER9KCGYDS93Z21"

    var userJSON = """
    {
        "name": "",
        "firstName": "",
        "lastName": "",
        "email": ""
    }
    """
    
    let pasteboard = UIPasteboard.general
    var deviceToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGestures()
        setupNotifications()
        setupUI()
        setupMessenger()
    }
    
    private final func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private final func setupNotifications() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.pushNotificationDelegate = self
        }
    }
    
    private final func setupUI() {
        self.title = "Deskpro Test App"
        
        appUrlTextfield.keyboardType = .URL
        appUrlTextfield.text = appUrl
        
        appIdTextfield.text = appId
        
        jwtTextview.delegate = self
        jwtTextview.layer.cornerRadius = 4
        jwtTextview.clipsToBounds = true
        jwtTextview.text = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZXNrcHJvX2lkIjoxfQ.6v-I8iuINBMUrEVSECZCURTztv0j4q61F3Q0DZZTbuo"
        
        userinfoTextview.delegate = self
        userinfoTextview.text = userJSON
        userinfoTextview.layer.cornerRadius = 4
        userinfoTextview.clipsToBounds = true
        
        eventLogTextView.isEditable = false
        eventLogTextView.layer.cornerRadius = 4
        eventLogTextView.clipsToBounds = true
    }
    
    private final func setupMessenger() {
        let messengerConfig = MessengerConfig(appUrl: appUrl, appId: appId)
        messenger = DeskPro(messengerConfig: messengerConfig, containingViewController: self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func appUrlUpdateBtnTapped(_ sender: Any) {
        if let url = appUrlTextfield.text,
           !url.isEmpty {
            appUrl = url
        }
        dismissKeyboard()
    }
    
    @IBAction func appIdUpdateBtnTapped(_ sender: Any) {
        if let id = appIdTextfield.text,
           !id.isEmpty {
            appId = id
        }
        dismissKeyboard()
    }
    
    @IBAction func setJwtBtnTapped(_ sender: Any) {
        if let jwt = jwtTextview.text,
           !jwt.isEmpty {
            messenger?.authorizeUser(userJwt: jwt)
            self.showToast(message: "JWT saved", font: .systemFont(ofSize: 13.0))
        }
        dismissKeyboard()
    }
    
    @IBAction func setUserinfoBtnTapped(_ sender: Any) {
        if let jsonString = userinfoTextview.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let jsonData = jsonString.data(using: .utf8),
           let user = try? JSONDecoder().decode(User.self, from: jsonData) {
            messenger?.setUserInfo(user: user)
            self.showToast(message: "User info saved", font: .systemFont(ofSize: 13.0))
        } else {
            self.showToast(message: "Invalid JSON input", font: .systemFont(ofSize: 13.0))
        }
        dismissKeyboard()
    }
    
    @IBAction func enableNotificationsBtnTapped(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    self?.logEvent("Notification permission granted!")
                }
            } else {
                self?.logEvent("Notification permission denied!")
            }
        }
    }
    
    @IBAction func openMessengerBtnTapped(_ sender: Any) {
        
        messenger?.eventRouter.handleEventCallback = { [weak self] event in
            self?.logEvent(event.debugDescription)
        }
        messenger?.present().show()
    }
    
    @IBAction func clearCookiesBtnTapped(_ sender: Any) {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
        self.showToast(message: "Cookies cleared", font: .systemFont(ofSize: 13.0))
    }
    
    @IBAction func copyTokenBtnTapped(_ sender: Any) {
        pasteboard.string = deviceToken
        self.showToast(message: "Device token copied to clipboard", font: .systemFont(ofSize: 13.0))
    }
    
    @IBAction func copyLogsBtnTapped(_ sender: Any) {
        pasteboard.string = eventLogTextView.text
        self.showToast(message: "Logs copied to clipboard", font: .systemFont(ofSize: 13.0))
    }
    
    private func logEvent(_ text: String) {
        let dashes = addLineOfDashes()
        
        eventLogTextView.text.append(("\(Date.nowString) [AppEvent] \(text)" + dashes))
        let bottom = NSMakeRange(eventLogTextView.text.count - 1, 1)
        eventLogTextView.scrollRangeToVisible(bottom)
    }
    
    private func addLineOfDashes() -> String {
        let dash = "-"
        let dashWidth = dash.size(withAttributes: [.font: eventLogTextView.font!]).width
        let textViewWidth = eventLogTextView.frame.width - eventLogTextView.textContainerInset.left - eventLogTextView.textContainerInset.right - 2 * eventLogTextView.textContainer.lineFragmentPadding
        let numberOfDashes = Int(floor(textViewWidth / dashWidth))
        
        return "\n\(String(repeating: dash, count: numberOfDashes))\n"
    }
}

extension ViewController: PushNotificationDelegate {
    
    func didRegisterForRemoteNotifications(withDeviceToken token: String, type: TokenType) {
        messenger?.setPushRegistrationToken(token: token)
        deviceToken = token
        self.logEvent("Fetched \(type) successfully: \(token)")
    }
}

extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
