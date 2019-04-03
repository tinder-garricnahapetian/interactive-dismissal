//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Present", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapPresent(button:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.sizeToFit()
        button.center = view.center
    }

    var didTapPresent: (() -> Void)?

    @objc
    private func didTapPresent(button: UIButton) {
        let flow = Flow()
        flow.start(presenter: self)
    }
}
