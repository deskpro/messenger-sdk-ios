//
//  WebView.swift
//
//  Created by QSD BiH on 4. 1. 2024..
//

import UIKit
import WebKit
 
///  The delegate to notify when WebView is dismissed and when an event occurs, which is important information for PresentCoordinator.
protocol WebViewDelegate: AnyObject {
    func webViewDismissed()
    func eventOccured(_ event: DeskproEvent)
}

///  The ViewController hosting WebView for DeskPro Messenger functionality. It manages the WebView, handles WebView configuration, and sets up communication with JavaScript. It also handles WebView lifecycle events and error handling.
final class CustomWebView: UIViewController {
    
    ///   The URL that should be loaded in WebView.
    var url: URL?
    private var appId: String = ""
    
    private var webView = WKWebView()
    private var activityIndicator = UIActivityIndicatorView()
    
    weak var delegate: WebViewDelegate?
    
    ///  UserDefaults utility for managing user information and JWT tokens.
    var appUserdefaults: DeskproUserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicator()
        
        loadUrlInWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.webViewDismissed()
    }

    ///  Basic WebView setup.
    private final func setupWebView() {
        webView = WKWebView(frame: view.bounds, configuration: setupWebViewConfiguration())
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        view.addSubview(webView)
    }
    
    ///  Basic ActivityIndicator setup.
    private final func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        
        view.addSubview(activityIndicator)
    }
    
    ///  Basic WebView configuration. Adds the message handler which will be a key for communication with JS.
    private final func setupWebViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        if #available(iOS 14.0, *) {
            configuration.userContentController.addScriptMessageHandler(self, contentWorld: .page, name: "iosListener")
        }
        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        return configuration
    }

    final func loadUrlInWebView() {
        if let url = url {
            let request = URLRequest(url: url)
            clearCookies()
            webView.load(request)
        } else {
            dprint("Url not provided")
        }
    }
    
    private final func clearCookies() {
        HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    }
    
    private final func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    ///  Preparing WebView.
    final func configure(_ url: URL, _ appId: String) {
        self.url = url
        self.appId = appId
        self.appUserdefaults = DeskproUserDefaults(appId: appId)
    }
    
    private final func evaluateJSFromSwift(script: String) {
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                dprint("Error: \(error)")
            } else if let result = result {
                dprint("Result: \(result)")
            }
        }
    }
}

extension CustomWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard case .linkActivated = navigationAction.navigationType,
              let url = navigationAction.request.url
        else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        UIApplication.shared.open(url)
    }
    
    final func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.evaluateJSFromSwift(script: InjectionScripts.initAndOpenScript)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showActivityIndicator(show: false)
        }
    }
    
    final func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    final func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
    final func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
        let htmlFileName = "error_page.html"
        let frameworkBundle = Bundle(for: type(of: self))
        
        if let htmlPath = frameworkBundle.path(forResource: htmlFileName, ofType: nil) {
            let fileUrl = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(fileUrl, allowingReadAccessTo: fileUrl)
        }
    }
}

extension CustomWebView: WKUIDelegate {
    
    final func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
        
        completionHandler()
    }
}

///  Methods that will be called by JavaScript.
extension CustomWebView {
    
    private final func close() {
        self.dismiss(animated: true)
    }
    
    private final func reloadPage() {
        self.loadUrlInWebView()
    }
    
    private final func getUserInfo() -> String {
        guard let userInfo = appUserdefaults?.getUserInfoJson() else { return "" }
        return userInfo
    }
    
    private final func getJwtToken() -> String {
        guard let jwtToken = appUserdefaults?.getJwtToken() else { return "" }
        return jwtToken
    }
    
    private final func getDeviceToken() -> String {
        guard let deviceToken = appUserdefaults?.getDeviceToken() else { return "" }
        return deviceToken
    }
}

extension CustomWebView: WKScriptMessageHandlerWithReply {
    
    ///  Triggered by postMessage(window.webkit.messageHandlers.iosListener.postMessage(...))
    @available(iOS 14.0, *)
    final func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
        dprint("WKWebView has received a message: `\(message.body)`")
        
        guard let messageBody = message.body as? String else { return (nil, nil) }

        if messageBody.contains(DeskproEvent.eventPrefix) {
            handleEvent(messageBody)
            return (nil, nil)
        }
        
        guard let postedMessage = PostMessageFunctions(rawValue: messageBody) else { return (nil, nil) }
        
        switch postedMessage {
        case .closeWebView:
            close()
        case .reloadPage:
            reloadPage()
        case .getUserInfo:
            return(getUserInfo(), nil)
        case .getUserJwtToken:
            return(getJwtToken(), nil)
        case .getDeviceToken:
            return(getDeviceToken(), nil)
        }
        
        return (nil, nil)
    }
    
    ///  Notify subscribers that appEvent or customEvent has been triggered.
    final func handleEvent(_ eventString: String) {
        let event: DeskproEvent
        let data = eventString.replacingOccurrences(of: DeskproEvent.eventPrefix, with: "")
        
        if data.contains(DeskproEvent.newChat(data: "").containedIdentifier) {
            event = .newChat(data: data)
        } else if data.contains(DeskproEvent.chatEnded(data: "").containedIdentifier) {
            event = .chatEnded(data: data)
        } else if data.contains(DeskproEvent.chatUploadRequest(data: "").containedIdentifier) {
            event = .chatUploadRequest(data: data)
        } else if data.contains(DeskproEvent.newChatMessage(data: "").containedIdentifier) {
            event = .newChatMessage(data: data)
        } else {
            event = .custom(data: data)
        }
        
        delegate?.eventOccured(event)
    }
}

extension UIViewController {
    
    ///  Showing WebView on the screen.
    @discardableResult
    func presentMessenger(urlString: String, appId: String) -> CustomWebView {
        let customWebView = CustomWebView()
        
        customWebView.modalPresentationStyle = .overFullScreen
        
        if let url = URL(string: urlString) {
            customWebView.configure(url, appId)
        }
        
        present(customWebView, animated: true)
        return customWebView
    }
    
    ///  Script for making the webView non-zoomable. Users are allowed to zoom anywhere in the webView and webView autozooms when keyboard appears.
    var source: String {
        "var meta = document.createElement('meta');" +
        "meta.name = 'viewport';" +
        "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
        "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
    }
}

private enum PostMessageFunctions: String {
    
    case closeWebView = "closeWebView"
    case reloadPage = "reloadPage"
    case getUserInfo = "getUserInfo"
    case getUserJwtToken = "getUserJwtToken"
    case getDeviceToken = "getDeviceToken"
}

private enum InjectionScripts {
    
    static let initAndOpenScript = """
    window.DpMessengerOptions = {
        showLauncherButton: false,
        openOnInit: true,
        userInfo: window.webkit.messageHandlers.iosListener.postMessage("\(PostMessageFunctions.getUserInfo)"),
        signedUserInfo: undefined,
        launcherButtonConfig: undefined,
        messengerAppConfig: undefined,
        urlCacheableConfig: undefined,
    };

    window.DpMessengerConnection = {
      parentMethods: {
        ready: async (messengerId) => {
          const data = await window.DpMessengerConnection.childMethods?.init(messengerId, {
            showLauncherButton: DpMessengerOptions.showLauncherButton,
            userInfo: window.DpMessengerOptions?.userInfo,
            launcherButtonConfig: DpMessengerOptions.launcherButtonConfig,
            messengerAppConfig: DpMessengerOptions.messengerAppConfig,
            parentViewDimensions: "fullscreen",
            open: DpMessengerOptions.openOnInit,
          });

          if (data) {
            const { side, offsetBottom, offsetSide, width, height } = data;
          }
    
          const deviceToken = await window.webkit.messageHandlers.iosListener.postMessage("\(PostMessageFunctions.getDeviceToken)");
          
          window.DpMessengerConnection.childMethods?.setDeviceToken(messengerId, {
              token: deviceToken
          });
        },
        getViewDimensions: async (messengerId) => {
          return "fullscreen";
        },
        getSignedUserInfo: async (messengerId) => {
            const jwt = await window.webkit.messageHandlers.iosListener.postMessage("\(PostMessageFunctions.getUserJwtToken)")
            // alert(jwt)
            return jwt
        },
        open: async (messengerId, data) => {
            const { width, height } = data;
        },
        close: async (messengerId, data) => {
            const result = await window.webkit.messageHandlers.iosListener.postMessage("\(PostMessageFunctions.closeWebView)")
        },
        appEvent: async (messengerId, event) => {
            //alert(event.id)
            var jsonEvent = JSON.stringify(event);
            window.webkit.messageHandlers.iosListener.postMessage("\(DeskproEvent.eventPrefix)" + jsonEvent)
        },
      },
      childMethods: undefined,
    };
    """
    
    static let logoutScript = """
        window.DpMessengerConnection.childMethods.logout("1");
    """
}
