//
//  ViewController.swift
//  SwiftExample
//
//  Created by QSD BiH on 5. 1. 2024..
//

import UIKit
import messenger_sdk_ios
import UserNotifications

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
    
    var messenger: DeskPro?
    
    var appUrl = "https://dev-pr-12927.earthly.deskprodemo.com/deskpro-messenger/deskpro/1/d"
    var userJSON = """
    {
        "name": "",
        "firstName": "",
        "lastName": "",
        "email": ""
    }
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Deskpro Test App"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    
        urlTextfield.keyboardType = .URL
        urlTextfield.text = appUrl
        
        jwtTextview.delegate = self
        
        userinfoTextview.delegate = self
        userinfoTextview.text = userJSON
        
        eventLogTextView.isEditable = false
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
            self?.eventLogTextView.text.append(event.debugDescription + "\n")
        }
        messenger?.present().show()
    }
    
    @IBAction func openNewChatBtnTapped(_ sender: Any) {}
    
    private func logEvent(_ text: String) {
        eventLogTextView.text.append(("\(Date.nowString) [AppEvent] \(text)" + "\n"))
        let bottom = NSMakeRange(eventLogTextView.text.count - 1, 1)
        eventLogTextView.scrollRangeToVisible(bottom)
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
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 45))
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
