//
//  CategoryHeaderView.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 10/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import UIKit

enum SelectState: Int {

    case None = 0, Full, Half
}


class CategoryHeaderView: UIView {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    var onPressCheckButton: (() -> Void)?
    var onPressExpandButton: (() -> Void)?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public Interface

    func configure(_ selectState: SelectState, isExpand: Bool, title: String) {

        titleLabel.text = title
        select(selectState: selectState)
        expand(expand: isExpand)
    }

    func select(selectState: SelectState) {

        switch selectState {
        case .None: checkButton.setImage(UIImage(named: "LCheckBox_Empty.png"), for: .normal)
        case .Half:
            checkButton.setImage(UIImage(named: "LCheckBox_Half.png"), for: .normal)
        case .Full:
            checkButton.setImage(UIImage(named: "LCheckBox_Full.png"), for: .normal)
        }
    }

    func expand(expand: Bool) {

        if expand {
            expandButton.setImage(UIImage(named: "DownArrow.png"), for: .normal)
        } else {
            expandButton.setImage(UIImage(named: "RightArrow.png"), for: .normal)
        }
    }

    // MARK: - Target & Action

    @IBAction func didPressCheckButton(_ sender: AnyObject) {

        onPressCheckButton?()
    }

    @IBAction func didPressExpandButton(_ sender: AnyObject) {

        onPressExpandButton?()
    }

}
