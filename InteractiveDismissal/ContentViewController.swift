//
//  ContentViewController.swift
//  InteractiveDismissal
//
//  Created by Garric Nahapetian on 4/3/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class ContentViewController: UIViewController {

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Push", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapPush(button:)), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(button)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    var didTapPush: (() -> Void)?

    @objc
    private func didTapPush(button: UIButton) {
        didTapPush?()
    }
}
