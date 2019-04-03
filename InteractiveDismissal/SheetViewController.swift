//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class SheetViewController: UIViewController {

    let contentViewController: UIViewController

    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        // MARK: - Handle Bar

        let handleBarContainerView = UIView()
        handleBarContainerView.layer.cornerRadius = 15
        handleBarContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        handleBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handleBarContainerView)
        let handleBarContainerViewConstraints = [
            handleBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            handleBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            handleBarContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            handleBarContainerView.heightAnchor.constraint(equalToConstant: 33),
        ]

        let handleBarView = UIView()
        handleBarView.backgroundColor = .lightGray
        handleBarView.layer.cornerRadius = 2.5
        handleBarView.translatesAutoresizingMaskIntoConstraints = false
        handleBarContainerView.addSubview(handleBarView)
        let handleBarViewConstraints = [
            handleBarView.widthAnchor.constraint(equalToConstant: 35),
            handleBarView.heightAnchor.constraint(equalToConstant: 5),
            handleBarView.centerXAnchor.constraint(equalTo: handleBarContainerView.centerXAnchor),
            handleBarView.topAnchor.constraint(equalTo: handleBarContainerView.topAnchor, constant: 5),
        ]

        let bottomBorderView = UIView()
        bottomBorderView.backgroundColor = .lightGray
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        handleBarContainerView.addSubview(bottomBorderView)
        let bottomBorderViewConstraints = [
            bottomBorderView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomBorderView.leadingAnchor.constraint(equalTo: handleBarContainerView.leadingAnchor),
            bottomBorderView.trailingAnchor.constraint(equalTo: handleBarContainerView.trailingAnchor),
            bottomBorderView.bottomAnchor.constraint(equalTo: handleBarContainerView.bottomAnchor),
        ]

        // MARK: - Content View Controller

        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)

        let contentView = contentViewController.view!
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let contentViewConstraints = [
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: handleBarContainerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        NSLayoutConstraint.activate(
            handleBarContainerViewConstraints
            + handleBarViewConstraints
            + bottomBorderViewConstraints
            + contentViewConstraints
        )
    }
}
