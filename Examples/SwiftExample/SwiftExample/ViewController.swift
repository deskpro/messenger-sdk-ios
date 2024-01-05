//
//  ViewController.swift
//  SwiftExample
//
//  Created by QSD BiH on 5. 1. 2024..
//

import UIKit
import DeskproFramework

class ViewController: UIViewController {

    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var testLbl: UILabel!
    @IBOutlet weak var openBtn: UIButton!
    
    let deskproUrlString = "https://www.deskpro.com"
    let messengerUrlString = "http://178.62.74.147:3001/d/B0ED0B34-8507-4248-8738-0B0D80A6F7E9/"
    let messengerConfig = MessengerConfig(appUrl: "http://178.62.74.147:3001/d/", appId: "B0ED0B34-8507-4248-8738-0B0D80A6F7E9")
    var messenger: DeskPro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messenger = DeskPro(messengerConfig: messengerConfig)
        
        messenger?.present().show()
    }

    @IBAction func testTapped(_ sender: Any) {
        if let messenger {
            testLbl.text = messenger.test()
        }
    }
    
    @IBAction func openTapped(_ sender: Any) {
        openWebView(urlString: messengerUrlString)
    }
    
    private func openWebView(urlString: String) {
        let customWebView = CustomWebView()

        if let url = URL(string: urlString) {
            customWebView.configureURL(url)
        }

        present(customWebView, animated: true)
    }
}

