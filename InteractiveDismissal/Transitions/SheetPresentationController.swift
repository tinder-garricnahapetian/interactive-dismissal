//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class SheetPresentationController: UIPresentationController {

    let animatedPresentation: VerticalPresentationTransition = VerticalPresentationTransition(proportion: 0.7)

    private(set) var animatedDismissal: DismissalTransition?
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

        presentedView?.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(didPan))

        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(didTapOutside(gesture:)))
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
    private func didTapOutside(gesture: UITapGestureRecognizer) {
        animatedDismissal = DismissalTransition(isInteractive: false)
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
            animatedDismissal = DismissalTransition(isInteractive: true)
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

    func animate() {
        UIView.animate(withDuration: 5) {
            self.presentedView?.frame = UIScreen.main.bounds
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SheetPresentationController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return tapGesture == gestureRecognizer && touch.view == containerView
    }
}

// MARK: - Dismissal Transition

extension SheetPresentationController {

    final class DismissalTransition: NSObject {

        let isInteractive: Bool
        let duration: TimeInterval

        init(isInteractive: Bool = false, duration: TimeInterval = 0.3) {
            self.isInteractive = isInteractive
            self.duration = duration
        }
    }
}

extension SheetPresentationController.DismissalTransition: UIViewControllerAnimatedTransitioning {

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: .from) else {
            return
        }

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: duration, animations: {
            presentedView.frame.origin.y = transitionContext.containerView.frame.height
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)

            guard self.isInteractive else {
                return
            }

            if transitionContext.transitionWasCancelled {
                transitionContext.cancelInteractiveTransition()
            } else {
                transitionContext.finishInteractiveTransition()
            }
        }
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
