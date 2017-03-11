//
//  ListButton.swift
//  UCSD-CSSA-What-To-Eat
//
//  Created by Yilun Liu on 10/20/16.
//  Copyright © 2016 Ruiqing Qiu. All rights reserved.
//

import Foundation
import UIKit

class ListButton: UIView {
    
    let LABEL_COLOR = UIColor(red: 242.0/255.0, green: 160.0/255.0, blue: 47.0/255.0, alpha: 1)
    let BUTTON_LEFT_PADDING: CGFloat = 8.0
    let BUTTON_TOP_PADDING: CGFloat = 5.0

    @IBOutlet weak var button: UIButton!
    var contentView: UIView!

    var onPressButton: (() -> Void)?

    // MARK: - Lifecycle

    override init(frame: CGRect) {

        super.init(frame: frame)
        setupXIB()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setupXIB()
        setup()
    }

    // MARK: - Setup

    private func setup() {

        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear

        button.layer.borderWidth = 1
        button.layer.borderColor = LABEL_COLOR.cgColor
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
    }

    private func setupXIB() {

        contentView = loadViewFromNib()
        contentView.frame = self.bounds
        addSubview(contentView)
    }

    // MARK: - Public Interface
    
    func setName(_ name: String) {

        button.setTitle(name, for: .normal)
    }

    func highlight(_ isHighlight: Bool) -> Void {

        if isHighlight {
            button.layer.backgroundColor = LABEL_COLOR.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
        } else {
            button.layer.cornerRadius = 10
            button.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
            button.setTitleColor(LABEL_COLOR, for: .normal)
        }
    }

    // Private Helpers

    private func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    // MARK: - Target & Action

    @IBAction func didPressButton(_ sender: AnyObject) {

        onPressButton?()
    }
}
