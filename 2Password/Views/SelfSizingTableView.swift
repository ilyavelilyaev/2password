//
//  SelfSizingTableView.swift
//  2Password
//
//  Created by Ilya Velilyaev on 06.12.17.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit

class SelfSizingTableView: UITableView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        let height = contentSize.height - contentInset.top - contentInset.bottom
        return CGSize(width: -1, height: height)
    }
    
}
