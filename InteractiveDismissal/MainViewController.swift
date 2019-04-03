//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {

    private let transitioningAdaptor: ViewControllerTransitioningAdapter = .init()

    private var sheetPresentationController: SheetPresentationController?

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Present", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.sizeToFit()
        button.center = view.center
        setupAdapter()
    }

    private func setupAdapter() {
        transitioningAdaptor
            .presentationController { [weak self] presentation in
                self?.sheetPresentationController = nil
                self?.sheetPresentationController = SheetPresentationController(presentation: presentation)
                return self?.sheetPresentationController?
                    .onTapOutside {
                        presentation.presented.dismiss(animated: true)
                    }
                    .onPanBegan {
                        presentation.presented.dismiss(animated: true)
                    }
            }
            .animatedPresentation { [weak self] _ in
                return self?.sheetPresentationController?.animatedPresentation
            }
            .animatedDismissal { [weak self] _ in
                return self?.sheetPresentationController?.animatedDismissal
            }
            .interactiveDismissal { [weak self] _ in
                return self?.sheetPresentationController?.interactiveDismissal
            }
    }
    
    @objc
    private func didTap(button: UIButton) {
        presentSheetViewController()
    }

    let contentViewController = UIViewController()
    lazy var myNavigationController = UINavigationController(rootViewController: contentViewController)

    private func presentSheetViewController() {
//        contentViewController.view.backgroundColor = .white
        contentViewController.view.layer.cornerRadius = 15
        contentViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentViewController.view.layer.masksToBounds = true

        myNavigationController.modalPresentationStyle = .custom
        myNavigationController.transitioningDelegate = transitioningAdaptor
        contentViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(didTapPush)
        )

        myNavigationController.navigationBar.layer.cornerRadius = 15
        myNavigationController.navigationBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        myNavigationController.navigationBar.layer.masksToBounds = true

        myNavigationController.navigationBar.subviews.forEach {
            $0.layer.cornerRadius = 15
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        present(myNavigationController, animated: true)
    }

    let otherAdaptor = ViewControllerTransitioningAdapter()

    @objc
    private func didTapPush(sender: UIBarButtonItem) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        viewController.view.layer.cornerRadius = 15
        viewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewController.view.layer.masksToBounds = true
        myNavigationController.pushViewController(viewController, animated: true)
    }
}

private extension SheetPresentationController {

    convenience init(presentation: ViewControllerTransitioningAdapter.Presentation) {
        self.init(presentedViewController: presentation.presented, presenting: presentation.presenting)
    }
}
