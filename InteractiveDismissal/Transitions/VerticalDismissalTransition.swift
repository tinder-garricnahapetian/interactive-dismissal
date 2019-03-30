//
//  VerticalDismissalTransition.swift
//  InteractiveDismissal
//
//  Created by Garric Nahapetian on 3/28/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class VerticalDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let isInteractive: Bool
    let duration: TimeInterval

    init(isInteractive: Bool = false, duration: TimeInterval = 0.3) {
        self.isInteractive = isInteractive
        self.duration = duration
    }

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
