//
//  CheckBox.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/25.
//

import UIKit

final class CheckBox: UIButton {
    // Image
    let checkedImage = UIImage(systemName: "checkmark.circle")
    let uncheckedImage = UIImage(systemName: "circle")

    // Bool property
    var isChecked:Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            }else{
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}



