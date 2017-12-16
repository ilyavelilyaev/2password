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

    private let viewModel = CatalogueViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        createNewButton.title = "Create new +"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.viewWillAppear()
        removeAllViews()
        configureViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func removeAllViews() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    private func configureViews() {
        for section in 0..<viewModel.numberOfSectionsInCatalogue() {
            let cellView = MainCatalogueCellView()
            cellView.title = viewModel.titleForSectionInCatalogue(section)
            cellView.tapCallback = { [unowned self, unowned cellView] in
                self.expandOrCollapse(section: section, cellView: cellView)
            }
            stackView.addArrangedSubview(cellView)
        }
    }

    private func expandOrCollapse(section: Int, cellView: MainCatalogueCellView) {
        guard let index = stackView.arrangedSubviews.index(of: cellView) else { return }
        if (index + 1) < stackView.arrangedSubviews.count, stackView.arrangedSubviews[index + 1] is CatalogueExpandedCellView {
            //collapse
            let viewToCollapse = stackView.arrangedSubviews[index + 1]
            viewToCollapse.removeFromSuperview()
        } else {
            //expand
            let expandedView = CatalogueExpandedCellView()
            let storedItems = viewModel.items(in: section)
            expandedView.items = storedItems.map({ item in return CatalogueCellItem(title: item.typedContent.showingTitle, callback: { [unowned self] in
                self.show(item: item)
            }) })
            stackView.insertArrangedSubview(expandedView, at: index + 1)
        }
    }

    private func show(item: SavedDataItem) {
        let singleEntryVC = SingleEntryViewController.instantiate(entry: item, mode: .view)

        navigationController?.pushViewController(singleEntryVC, animated: true)
    }
    
    @IBAction func createNewPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Select Type of data to create", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (_) in
            let singleEntryVC = SingleEntryViewController.instantiate(entry: nil, mode: .create(type: .login))

            self.navigationController?.pushViewController(singleEntryVC, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Credit card", style: .default, handler: { (_) in
            let singleEntryVC = SingleEntryViewController.instantiate(entry: nil, mode: .create(type: .creditCard))

            self.navigationController?.pushViewController(singleEntryVC, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Note", style: .default, handler: { (_) in
            let singleEntryVC = SingleEntryViewController.instantiate(entry: nil, mode: .create(type: .note))

            self.navigationController?.pushViewController(singleEntryVC, animated: true)
        }))

        present(alert, animated: true, completion: nil)
    }

}
