//
//  SingleEntryTableViewCell.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class SingleEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitleLabel: UILabel!
    @IBOutlet weak var entryTextField: UITextField!

    var onEditingChanged: (String) -> Void = { _ in }

    override func awakeFromNib() {
        super.awakeFromNib()
        entryTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    @objc private func editingChanged() {
        onEditingChanged(self.entryTextField.text ?? "")
    }
    
}
