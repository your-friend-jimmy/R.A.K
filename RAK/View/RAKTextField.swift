//
//  RAKTextField.swift
//  RAK
//
//  Created by James Phillips on 7/17/21.
//

import UIKit

class RAKTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftViewMode = .always
        autocorrectionType = .no
        layer.cornerRadius = 8
        layer.borderWidth = 1
        backgroundColor = .secondarySystemBackground
        layer.borderColor = UIColor.secondaryLabel.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
