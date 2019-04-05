//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class SheetPresentationController: UIPresentationController {

    var handleBarView: UIView?
    var scrollView: UIScrollView?

    var isInteractivelyDismissing: Bool {
        return interactiveDismissal != nil
    }

    let animatedPresentation: VerticalPresentationTransition = VerticalPresentationTransition(proportion: 0.7)

    private(set) var animatedDismissal: VerticalDismissalTransition?
    private(set) var interactiveDismissal: UIPercentDrivenInteractiveTransition? {
        didSet {
            if interactiveDismissal == nil {
                animatedDismissal = nil
            } else {
                animatedDismissal = VerticalDismissalTransition(isInteractive: true)
            }
            setScrollViewState(isBeingDismissed: interactiveDismissal != nil)
        }
    }

    private let tapGesture: UITapGestureRecognizer = .init()
    private let panGesture: UIPanGestureRecognizer = .init()

    private var didTapOutside: (() -> Void)?
    private var didBeginPan: (() -> Void)?

    private var shouldFinishInteractiveTransition: Bool = false

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = containerView, let presentedView = presentedView else {
            return
        }
//        presentedView.layer.cornerRadius = 15
//        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
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
        if isInteractivelyDismissing {
            updateInteractiveDismissal(gesture: gesture)
            return
        }
        if isDraggingHandleBarView(gesture: gesture) {
            updateInteractiveDismissal(gesture: gesture)
            return
        }
        if let scrollView = scrollView {
            handlePan(gesture: gesture, for: scrollView)
            return
        }
        updateInteractiveDismissal(gesture: gesture)
    }

    private func handlePan(gesture: UIPanGestureRecognizer, for scrollView: UIScrollView) {
        guard shouldBeginDismissing(scrollView: scrollView) else {
            // ignore pan until true
            return
        }
        updateInteractiveDismissal(gesture: gesture)
    }

    private func isDraggingHandleBarView(gesture: UIPanGestureRecognizer) -> Bool {
        let pointInPresentedView = gesture.location(in: presentedView)
        let touchedViewInPresentedView: UIView? = handleBarView?.hitTest(pointInPresentedView, with: nil)
        return touchedViewInPresentedView != nil
    }

    private func updateInteractiveDismissal(gesture: UIPanGestureRecognizer) {
        startInteractiveDismissalIfNeeded()
        switch gesture.state {
        case .changed:
            guard let view = containerView else {
                break
            }
            let percentThreshold: CGFloat = 0.3 // TODO: make settable?
            let progress = computeProgress(from: gesture, in: view)
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

    private func computeProgress(from gesture: UIPanGestureRecognizer, in view: UIView) -> CGFloat {
        let translation = gesture.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        return CGFloat(downwardMovementPercent)
    }

    private func startInteractiveDismissalIfNeeded() {
        if interactiveDismissal == nil {
            interactiveDismissal = UIPercentDrivenInteractiveTransition()
            didBeginPan?()
        }
    }

    private func shouldBeginDismissing(scrollView: UIScrollView) -> Bool {
        let isAtTopOrBeyond = scrollView.contentOffset.y <= -(scrollView.adjustedContentInset.top)
        let panGesture = scrollView.panGestureRecognizer
        let isDragging = scrollView.isDragging
        let isDraggingDown = isDragging && panGesture.velocity(in: scrollView).y > 0
        return isAtTopOrBeyond && isDraggingDown
    }

    private func setScrollViewState(isBeingDismissed: Bool) {
        scrollView?.bounces = isBeingDismissed ? false : true
        scrollView?.showsVerticalScrollIndicator = isBeingDismissed ? false : true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SheetPresentationController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == tapGesture {
            return touch.view == containerView
        }
        if gestureRecognizer == panGesture, let presentedView = presentedView {
            let touchPoint = touch.location(in: presentedView)
            return presentedView.point(inside: touchPoint, with: nil)
        }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
