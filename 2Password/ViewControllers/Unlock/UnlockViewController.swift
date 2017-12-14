//
//  UnlockViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class UnlockViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var button: GradientButton!
    private var completion: () -> Void = { }

    static func instantiate(completion: @escaping () -> Void) -> UnlockViewController {
        let sb = UIStoryboard(name: "Unlock", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "UnlockViewController") as! UnlockViewController
        vc.completion = completion
        return vc
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "Unlock"
        button.title = "Unlock"
    }
    
    @IBAction func unlockButtonPressed(_ sender: Any) {
        checkPassword()
    }

    private func checkPassword() {
        guard let p1 = passwordTF.text, !p1.isEmpty else {
            showAlert(text: "Please enter password.")
            return
        }

        guard SecurityEngine.shared.unlock(password: p1) else {
            showAlert(text: "Password doesn't match")
            return
        }

        completion()
    }

    private func showAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
