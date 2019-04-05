//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var flow: Flow?

    private lazy var presentStaticViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Present Static View", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapPresentStaticView(button:)), for: .touchUpInside)
        return button
    }()

    private lazy var presentTableViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Present Table View", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapPresentTableView(button:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(presentStaticViewButton)
        presentStaticViewButton.sizeToFit()
        presentStaticViewButton.center = view.center

        view.addSubview(presentTableViewButton)
        presentTableViewButton.translatesAutoresizingMaskIntoConstraints = false
        presentTableViewButton.topAnchor.constraint(equalTo: presentStaticViewButton.bottomAnchor).isActive = true
        presentTableViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    var didTapPresentStaticView: (() -> Void)?
    var didTapPresentTableView: (() -> Void)?

    @objc
    private func didTapPresentStaticView(button: UIButton) {
        flow = Flow()
        flow?.start(statically: true, presenter: self)
    }

    @objc
    private func didTapPresentTableView(button: UIButton) {
        flow = Flow()
        flow?.start(statically: false, presenter: self)
    }
}
