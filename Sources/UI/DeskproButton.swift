//
//  DeskproButton.swift
//
//  Created by QSD BiH on 15. 1. 2024..
//

import UIKit

///  DeskproButton is a customizable, rounded UIButton subclass that provides an easy way to create a floating action button with shadow effects and configurable positioning within a view. It supports setting images, colors, and position with minimal setup.
public class DeskproButton: UIButton {

    ///  Stores the width (and height, as it's a circle) of the button.
    private var sizeWidth: CGFloat = 56
    
    ///  Initializes the button with a specified size. Default size is 56.
    public init(size: CGFloat = 56) {
        super.init(frame: .zero)
        self.sizeWidth = size
        self.frame.size = CGSize(width: sizeWidth, height: sizeWidth)
        
        configure()
    }
    
    ///  Required initializer for decoding the button from a nib or storyboard.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sizeWidth = self.frame.size.width
        configure()
    }

    ///   Method to configure the button's shadow, corner radius, and background color. It is called automatically during initialization.
    private func configure() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        self.layer.shadowOffset = CGSize(width: sizeWidth / 28, height: sizeWidth / 28)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = sizeWidth / 18
        self.layer.masksToBounds = false
        self.layer.cornerRadius = sizeWidth / 2
        self.backgroundColor = .deskproLightBlue
    }
    
    ///  Sets the button image with an optional tint color.
    public func setImage(named imageName: String, color: UIColor? = nil) {
        let image = UIImage(named: imageName)
        self.setImage(image, for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
        if let color {
            let templateImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
            self.setImage(templateImage, for: .normal)
            self.imageView?.tintColor = color
        }
        let inset = sizeWidth / 5
        self.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    ///   Sets the background color of the button.
    public func setColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    ///  Positions the button within the specified view. Allows for predefined positions (top/bottom, left/right) or a custom point.
    public func setPosition(_ position: ButtonPosition, inView view: UIView, x: CGFloat = 16, y: CGFloat = 16) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.removeConstraints(self.constraints)
        
        switch position {
        case .topLeft:
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: y).isActive = true
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: x).isActive = true
        case .topRight:
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: y).isActive = true
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -x).isActive = true
        case .bottomLeft:
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -y).isActive = true
            self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: x).isActive = true
        case .bottomRight:
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -y).isActive = true
            self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -x).isActive = true
        case .custom(let point):
            self.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: point.x).isActive = true
            self.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: point.y).isActive = true
        }
        self.widthAnchor.constraint(equalToConstant: sizeWidth).isActive = true
        self.heightAnchor.constraint(equalToConstant: sizeWidth).isActive = true
    }
    
    ///  Defines the position of the button.
    public enum ButtonPosition {
        case topLeft, topRight, bottomLeft, bottomRight
        case custom(CGPoint)
    }
}

