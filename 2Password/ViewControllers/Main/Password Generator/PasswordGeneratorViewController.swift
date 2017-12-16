//
//  PasswordGeneratorViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 16/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class PasswordGeneratorViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var slider: UISlider!

    private var generatedPassword: String = "" {
        didSet {
            passwordLabel.text = generatedPassword
        }
    }

    let passwordGenerator = PasswordGenerator()

    static func instantiate() -> PasswordGeneratorViewController {
        let sb = UIStoryboard(name: "PasswordGenerator", bundle: .main)
        return sb.instantiateViewController(withIdentifier: "PasswordGeneratorViewController") as! PasswordGeneratorViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(copyPressed))
        generatedPassword = passwordGenerator.generatePassword(length: 10)
    }

    @objc private func copyPressed() {
        UIPasteboard.general.string = generatedPassword

        let alert = UIAlertController(title: "Success", message: "Password copied to pasteboard", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        generatedPassword = passwordGenerator.generatePassword(length: Int(sender.value))
    }


}
