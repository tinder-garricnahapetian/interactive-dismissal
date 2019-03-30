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
        let sheet = SheetViewController()
        sheet.modalPresentationStyle = .custom
        sheet.transitioningDelegate = transitioningAdaptor
        present(sheet, animated: true, completion: nil)
    }
}

private extension SheetPresentationController {

    convenience init(presentation: ViewControllerTransitioningAdapter.Presentation) {
        self.init(presentedViewController: presentation.presented, presenting: presentation.presenting)
    }
}
