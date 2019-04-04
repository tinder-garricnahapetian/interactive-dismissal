//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class SheetPresentationController: UIPresentationController {

    let animatedPresentation: VerticalPresentationTransition = VerticalPresentationTransition(proportion: 0.7)

    private(set) var animatedDismissal: VerticalDismissalTransition?
    private(set) var interactiveDismissal: UIPercentDrivenInteractiveTransition?

    private let tapGesture: UITapGestureRecognizer = .init()
    private let panGesture: UIPanGestureRecognizer = .init()

    private var didTapOutside: (() -> Void)?
    private var didBeginPan: (() -> Void)?

    private var shouldFinishInteractiveTransition: Bool = false

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView else {
            return
        }

        presentedViewController.view.layer.cornerRadius = 15
        presentedViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedViewController.view.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(didPan))

        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(tapped))
        containerView.addGestureRecognizer(tapGesture)
        containerView.backgroundColor = .clear

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        })
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.containerView?.backgroundColor = .clear
        })
    }

    @discardableResult
    public func onTapOutside(_ closure: @escaping () -> Void) -> Self {
        didTapOutside = closure
        return self
    }

    @discardableResult
    public func onPanBegan(_ closure: @escaping () -> Void) -> Self {
        didBeginPan = closure
        return self
    }

    @objc
    private func tapped() {
        animatedDismissal = VerticalDismissalTransition(isInteractive: false)
        didTapOutside?()
    }

    @objc
    private func didPan(gesture: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3

        guard let view = gesture.view else {
            return
        }

        // convert y-position to downward pull progress (percentage)
        let translation = gesture.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        switch gesture.state {
        case .began:
            animatedDismissal = VerticalDismissalTransition(isInteractive: true)
            interactiveDismissal = UIPercentDrivenInteractiveTransition()
            didBeginPan?()
        case .changed:
            shouldFinishInteractiveTransition = progress > percentThreshold
            interactiveDismissal?.update(progress)
        case .cancelled:
            interactiveDismissal?.cancel()
        case .ended:
            shouldFinishInteractiveTransition ? interactiveDismissal?.finish() : interactiveDismissal?.cancel()
            interactiveDismissal = nil
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SheetPresentationController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return tapGesture == gestureRecognizer && touch.view == containerView
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
