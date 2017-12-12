//
//  GradientButton.swift
//  2Password
//
//  Created by Ilya Velilyaev on 05.12.17.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import UIKit
import SnapKit

@objc
class GradientButton: UIControl {

    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }

    var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var titleLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13.0)
        label.isUserInteractionEnabled = false
        
        return label
    }()

    private var stackView: UIStackView = {

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
        stackView.isUserInteractionEnabled = false

        return stackView
    }()

    private var gradientView: UIImageView = {

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "gradientBackground")
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
        addSubviews()
        setupConstraints()
        setupEdges()
    }

    private func addSubviews() {
        addSubview(gradientView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
    }

    private func setupConstraints() {
        gradientView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        }
    }

    private func setupEdges() {
        layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }

}
