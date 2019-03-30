//
//  VerticalPresentationTransition.swift
//  InteractiveDismissal
//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class VerticalPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let duration: TimeInterval
    let proportion: CGFloat

    init(proportion: CGFloat = 1, duration: TimeInterval = 0.6) {
        self.proportion = proportion
        self.duration = duration
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let finalFrame = transitionContext.finalFrame(for: presentedViewController)
        let presentedView: UIView = presentedViewController.view
        transitionContext.containerView.addSubview(presentedView)
        presentedView.frame.size.height = finalFrame.height * proportion
        presentedView.frame.origin.y = finalFrame.height
        let duration = transitionDuration(using: transitionContext)
        let timing = UICubicTimingParameters.coverVertical
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        animator.addAnimations {
            presentedView.frame.origin.y = finalFrame.height - presentedView.frame.height
        }
        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        animator.startAnimation()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}

