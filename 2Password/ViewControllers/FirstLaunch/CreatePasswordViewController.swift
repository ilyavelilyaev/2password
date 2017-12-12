//
//  CreatePasswordViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 12/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController {

    private var completion: (String) -> Void = { _ in }
    @IBOutlet weak var button: GradientButton!

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmTF: UITextField!

    static func instantiate(completion: @escaping (String) -> Void) -> CreatePasswordViewController {
        let sb = UIStoryboard(name: "FirstLaunch", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "CreatePasswordViewController") as! CreatePasswordViewController
        vc.completion = completion
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.title = "Register"
    }

    @IBAction func buttonPressed(_ sender: Any) {
        checkPasswords()
    }

    private func checkPasswords() {
        guard let p1 = passwordTF.text, let p2 = passwordConfirmTF.text else {
            showAlert(text: "Please enter passwords.")
            return
        }

        guard p1 == p2 else {
            showAlert(text: "Passwords don't match.")
            return
        }

        guard p1.count >= 6 else {
            showAlert(text: "Minimum password length is 6 symbols.")
            return
        }

        completion(p1)
    }

    private func showAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
//
//    @IBAction func passwordEditingChanged(_ sender: Any) {
//        if let p1 = passwordTF.text {
//            passwordTF.isSecureTextEntry = !p1.isEmpty
//        }
//    }
//
//    @IBAction func passwordConfirmationEditingChanged(_ sender: Any) {
//        if let p2 = passwordConfirmTF.text {
//            passwordConfirmTF.isSecureTextEntry = !p2.isEmpty
//        }
//    }

}
