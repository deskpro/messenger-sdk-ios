//
//  PresentCoordinator.swift
//  DeskproFramework
//
//  Created by QSD BiH on 24. 1. 2024..
//

import UIKit

///  The coordinator for easier WebView presentation handling. It will make sure that only one instance of WebView is presented at the time.
public class PresentCoordinator: WebViewDelegate {
    
    ///  The ViewController from which the WebView will be presented.
    weak var containingViewController: UIViewController?
    
    var path: String = ""
    var webViewInstance: CustomWebView?
    var eventRouter: EventRouter
    
    public init(
        containingViewController: UIViewController,
        eventRouter: EventRouter
    ) {
        self.containingViewController = containingViewController
        self.eventRouter = eventRouter
    }
    
    ///  This method will check if WebView is already opened, and if yes, it will load another page inside the same WebView. If not, new WebView instance is created.
    final func present(path: String, appId: String) {
        self.path = path
        
        if webViewInstance == nil {
            webViewInstance = containingViewController?.presentMessenger(urlString: path, appId: appId)
            webViewInstance?.delegate = self
        } else {
            guard let url = URL(string: path) else { return }
            
            webViewInstance?.configure(url, appId)
            webViewInstance?.loadUrlInWebView()
        }
    }
    
    func webViewDismissed() {
        webViewInstance = nil
    }
    
    func eventOccured(_ event: DeskproEvent) {
        eventRouter.handleOrLogEvent(event: event)
    }
}
