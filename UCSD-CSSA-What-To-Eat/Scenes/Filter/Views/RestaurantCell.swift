//
//  RestaurantCell.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 10/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    var onPressCheckButton: (() -> Void)?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    // MARK: - Public Interface

    func configure(isChecked: Bool, title: String) {

        titleLabel.text = title
        check(isChecked: isChecked)
    }

    func check(isChecked: Bool) {

        if isChecked {
            checkButton.setImage(UIImage(named: "SCheckBox_Checked.png"), for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "SCheckBox_Empty.png"), for: .normal)
        }
    }
}
