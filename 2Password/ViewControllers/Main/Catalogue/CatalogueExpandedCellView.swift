//
//  CatalogueExpandedCellView.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

struct CatalogueCellItem {

    let title: String
    let callback: () -> Void

}

class CatalogueExpandedCellView: UIView {

    var items: [CatalogueCellItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView(frame: .zero, style: .plain)

        let nib = UINib(nibName: "ExpandedCatalogueTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "ExpandedCatalogueTableViewCell")

        tableView.separatorColor = .white
        tableView.separatorInset = .zero
        tableView.separatorStyle = .singleLine

        tableView.delegate = self
        tableView.dataSource = self

        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }


    private func setup() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension CatalogueExpandedCellView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandedCatalogueTableViewCell", for: indexPath) as! ExpandedCatalogueTableViewCell

        cell.titleLabel.text = items[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].callback()
    }

}
