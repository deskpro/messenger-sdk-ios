//
//  ViewController.swift
//  SwiftExample
//
//  Created by QSD BiH on 5. 1. 2024..
//

import UIKit
import messenger_sdk_ios

class ViewController: UIViewController {
    
    @IBOutlet weak var urlTextfield: UITextField!
    @IBOutlet weak var jwtTextview: UITextView!
    @IBOutlet weak var userinfoTextview: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var setJwtButon: UIButton!
    @IBOutlet weak var setUserinfoBtn: UIButton!
    @IBOutlet weak var enableNotificationsBtn: UIButton!
    @IBOutlet weak var openMessengetBtn: UIButton!
    @IBOutlet weak var openNewChatBtn: UIButton!
    @IBOutlet weak var eventLogTextView: UITextView!
    @IBOutlet weak var copyTokenBtn: UIButton!
    @IBOutlet weak var copyLogsBtn: UIButton!
    
    var messenger: DeskPro?
    
    var appUrl = "https://master.earthly.deskprodemo.com/deskpro-messenger/00000000-0000-0000-0000-000000000000/0000000000HXER9KCGYDS93Z21/%7B%22platform%22%3A%22IOS%22%7D"
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
        
        self.title = "Deskpro Test App"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.pushNotificationDelegate = self
        }

        urlTextfield.keyboardType = .URL
        urlTextfield.text = appUrl
        
        jwtTextview.delegate = self
        jwtTextview.layer.cornerRadius = 4
        jwtTextview.clipsToBounds = true
        
        userinfoTextview.delegate = self
        userinfoTextview.text = userJSON
        userinfoTextview.layer.cornerRadius = 4
        userinfoTextview.clipsToBounds = true
        
        eventLogTextView.isEditable = false
        eventLogTextView.layer.cornerRadius = 4
        eventLogTextView.clipsToBounds = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func updateBtnTapped(_ sender: Any) {
        if let url = urlTextfield.text,
           !url.isEmpty {
            appUrl = url
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
        let messengerConfig = MessengerConfig(appUrl: appUrl, appId: "1")
        messenger = DeskPro(messengerConfig: messengerConfig, containingViewController: self)
        messenger?.eventRouter.handleEventCallback = { [weak self] event in
            self?.logEvent(event.debugDescription)
        }
        messenger?.present().show()
    }
    
    @IBAction func openNewChatBtnTapped(_ sender: Any) {}
    
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

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 120, y: self.view.frame.size.height-100, width: 240, height: 45))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

private extension Date {
    
    static var nowString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
