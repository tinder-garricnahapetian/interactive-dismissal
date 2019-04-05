//
//  Flow.swift
//  InteractiveDismissal
//
//  Created by Garric Nahapetian on 4/3/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class Flow: NSObject {

    var sheetViewController: SheetViewController!
    let navigationController: UINavigationController = .init()

    var rootViewController: UIViewController!

    var contentViewController: ContentViewController? {
        return rootViewController as? ContentViewController
    }

    let transitioningAdaptor: ViewControllerTransitioningAdapter = .init()
    private var sheetPresentationController: SheetPresentationController?

    func start(statically: Bool, presenter: UIViewController) {
        if statically {
            let viewController = UIViewController()
            viewController.view.backgroundColor = .red
            rootViewController = viewController
        } else {
            rootViewController = makeContentViewController()
        }

        let handleBar = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 5))
        handleBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        handleBar.layer.cornerRadius = 2.5
        handleBar.layer.masksToBounds = true
        rootViewController.navigationItem.titleView = handleBar
        rootViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        let navigationBar = navigationController.navigationBar
        let image = UIImage(named: "TNDR2BarButtonBackIcon")!
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .red
        navigationBar.setTitleVerticalPositionAdjustment(-10, for: .default)
        navigationController.delegate = self
        navigationController.setViewControllers([rootViewController], animated: false)
        sheetViewController = SheetViewController(contentViewController: navigationController)
        sheetViewController.modalPresentationStyle = .custom
        sheetViewController.transitioningDelegate = configuredAdaptor()

        presenter.present(sheetViewController, animated: true) { [weak self] in
            self?.sheetPresentationController?.handleBarView = navigationBar
            self?.sheetPresentationController?.scrollView = self?.contentViewController?.tableView
        }
    }

    private func makeContentViewController() -> ContentViewController {
        let contentViewController = ContentViewController()
        contentViewController.didTapPushStaticView = { [weak self] in
            let staticViewController = UIViewController()
            staticViewController.view.backgroundColor = .red
            self?.navigationController.pushViewController(staticViewController, animated: true)
        }
        contentViewController.didTapPushTableView = { [weak self] in
            if let contentViewController = self?.makeContentViewController() {
                self?.navigationController.pushViewController(contentViewController, animated: true)
            }
        }
        return contentViewController
    }

    private func configuredAdaptor() -> ViewControllerTransitioningAdapter {
        return transitioningAdaptor
            .presentationController { [weak self] presentation in
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
}

// MARK: -

extension Flow: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let contentViewController = viewController as? ContentViewController {
            sheetPresentationController?.scrollView = contentViewController.tableView
        }
    }
}

// MARK: - Sheet Presentation Controller

private extension SheetPresentationController {

    convenience init(presentation: ViewControllerTransitioningAdapter.Presentation) {
        self.init(presentedViewController: presentation.presented, presenting: presentation.presenting)
    }
}

