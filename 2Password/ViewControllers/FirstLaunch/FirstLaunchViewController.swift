//
//  FirstLaunchViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 06/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class FirstLaunchViewController: UIViewController {

    private var completion: () -> Void = { }
    @IBOutlet weak var button: GradientButton!

    static func instantiate(completion: @escaping () -> Void) -> FirstLaunchViewController {
        let sb = UIStoryboard(name: "FirstLaunch", bundle: Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier: "FirstLaunchViewController") as! FirstLaunchViewController
        vc.completion = completion
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        button.title = "Create master password"
    }

    
    @IBAction func buttonPressed(_ sender: Any) {
        completion()
    }

}
