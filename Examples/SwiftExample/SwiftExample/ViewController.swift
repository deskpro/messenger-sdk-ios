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
    
    let messengerConfig = MessengerConfig(appUrl: "https://dev-pr-12730.earthly.deskprodemo.com/deskpro-messenger/deskpro/1/d/", appId: "1")
    
    var messenger: DeskPro?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messenger = DeskPro(messengerConfig: messengerConfig, containingViewController: self)
        
        setupLauncherButton()
    }

    @IBAction func testTapped(_ sender: Any) {
        testLbl.text = messenger?.test()
    }
    
    private func setupLauncherButton() {
        let floatingBtn = DeskproButton()
        floatingBtn.setColor(.systemBlue)
        floatingBtn.setImage(named: "messenger", color: .white)
        floatingBtn.addTarget(self, action: #selector(floatingBtnnTapped), for: .touchUpInside)
        self.view.addSubview(floatingBtn)
        floatingBtn.setPosition(.bottomRight, inView: self.view)
    }
    
    @objc private func floatingBtnnTapped() {
        messenger?.present().show()
    }
}

