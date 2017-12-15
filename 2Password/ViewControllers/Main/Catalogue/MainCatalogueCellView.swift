//
//  MainCatalogueCellView.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit
import SnapKit

class MainCatalogueCellView: UIView {

    var tapCallback: () -> Void = { }
    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(white: 95/255, alpha: 1.0)
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()

    private var disclosureImageView: UIImageView = {
        let image = #imageLiteral(resourceName: "disclosure")
        let imageView = UIImageView(image: #imageLiteral(resourceName: "disclosure"))
        return imageView
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
        addSubview(titleLabel)
        addSubview(disclosureImageView)

        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }

        disclosureImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(16)
            make.width.equalTo(9)
        }

        snp.makeConstraints { (make) in
            make.height.equalTo(54)
        }

        titleLabel.isUserInteractionEnabled = false
        disclosureImageView.isUserInteractionEnabled = false

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(gestureRecognizer)
    }

    @objc private func onTap() {
        tapCallback()
    }
}




