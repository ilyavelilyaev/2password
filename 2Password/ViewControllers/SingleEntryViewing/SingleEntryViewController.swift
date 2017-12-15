//
//  SingleEntryViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class SingleEntryViewController: UIViewController {

    @IBOutlet weak var generatePasswordButton: GradientButton!

    @IBOutlet weak var tableView: UITableView!

    static func instantiate(entry: SavedDataItem) -> SingleEntryViewController {
        let sb = UIStoryboard(name: "SingleEntry", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "SingleEntryViewController") as! SingleEntryViewController

        return vc
    }

    @IBAction func generatePasswordButtonPressed() {
        
    }

}
