//
//  ThankYouViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 12/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {

    static func instantiate() -> ThankYouViewController {
        let sb = UIStoryboard(name: "FirstLaunch", bundle: .main)
        return sb.instantiateViewController(withIdentifier: "ThankYouViewController") as! ThankYouViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

}
