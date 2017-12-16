//
//  SingleEntryViewController.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class SingleEntryViewController: UIViewController {

    enum Mode {
        case create(type: StoredDataType)
        case edit
        case view
    }

    @IBOutlet weak var tableView: UITableView!

    var entry: SavedDataItem?
    var mode: Mode!

    var creationItem: StoredData?

    var currentType: StoredDataType {
        switch mode! {
        case .create(let type): return type
        default:
            return entry!.dataType
        }
    }

    static func instantiate(entry: SavedDataItem?, mode: Mode) -> SingleEntryViewController {
        let sb = UIStoryboard(name: "SingleEntry", bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "SingleEntryViewController") as! SingleEntryViewController

        vc.entry = entry
        vc.mode = mode

        if case let .create(type) = mode {
            switch type {
            case .login: vc.creationItem = LoginData(login: "", password: "", siteName: "")
            case .creditCard: vc.creationItem = CreditCardData(cardHolderName: "", vendor: "", number: "", expiryDate: "", pin: "")
            case .note: vc.creationItem = SecureNoteData(noteName: "", note: "")
            }
        }

        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRightItem()
    }

    private func configureTableView() {
        tableView.rowHeight = 104
        tableView.delegate = self
        tableView.dataSource = self

        let nib = UINib(nibName: "SingleEntryTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "SingleEntryTableViewCell")
    }

    private func configureRightItem() {
        switch mode! {
        case .edit, .create:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed))
        case .view:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        }

    }

    @objc private func savePressed() {
        switch mode! {
        case .edit:
            CoreDataStack.shared.privateMOC.performAndWait {
                entry?.content = creationItem!.encode() as NSData
                try! CoreDataStack.shared.privateMOC.save()
            }
            mode = .view
            configureRightItem()
            tableView.reloadData()
        case .create:
            _ = creationItem?.saveDataItem()
            _ = navigationController?.popViewController(animated: true)
        default: break
        }

    }

    @objc private func editPressed() {
        self.creationItem = entry?.typedContent
        self.mode = .edit
        configureRightItem()
        tableView.reloadData()
    }

}

extension SingleEntryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entry?.typedContent.fields.count ?? currentType.fields.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleEntryTableViewCell", for: indexPath) as! SingleEntryTableViewCell
        let contentFields = entry?.typedContent.fields
        switch mode! {
        case .create(let type):
            cell.entryTextField.isUserInteractionEnabled = true
            cell.entryTextField.text = ""
            cell.entryTitleLabel.text = type.fields[indexPath.row]
            cell.onEditingChanged = { [unowned self] text in
                self.creationItem?.set(value: text, for: type.fields[indexPath.row])
            }
        case .view:
            cell.entryTitleLabel.text = contentFields![indexPath.row].0
            cell.entryTextField.text = contentFields![indexPath.row].1
            cell.entryTextField.isUserInteractionEnabled = false
        case .edit:
            let field = contentFields![indexPath.row].0
            cell.entryTitleLabel.text = field
            cell.entryTextField.text = contentFields![indexPath.row].1
            cell.entryTextField.isUserInteractionEnabled = true
            cell.onEditingChanged = { [unowned self] text in
                self.creationItem?.set(value: text, for: field)
            }
        }
        return cell
    }

}

