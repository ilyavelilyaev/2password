//
//  CatalogueViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class CatalogueViewController: UIViewController {
    
    @IBOutlet weak var createNewButton: GradientButton!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        createNewButton.title = "Create new +"
    }

    

}
