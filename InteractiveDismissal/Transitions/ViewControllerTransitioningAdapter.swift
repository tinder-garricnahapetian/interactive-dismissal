//
//  Created by Daniel Inoa on 3/21/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

/// ViewControllerTransitioningAdapter is a concrete implementation of UIViewControllerTransitioningDelegate
/// intended to forward delegate functions through closures.
final class ViewControllerTransitioningAdapter: NSObject, UIViewControllerTransitioningDelegate {

    struct Presentation {
        let presented: UIViewController
        let presenting: UIViewController?
        let source: UIViewController
    }

    // MARK: - Transition Animator Objects

    private var animatedPresentation: ((Presentation) -> UIViewControllerAnimatedTransitioning?)?
    private var animatedDismissal: ((_ dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?)?

    /// Asks for the transition animator object to use when presenting a view controller.
    @discardableResult
    func animatedPresentation(_ closure: @escaping ((Presentation) -> UIViewControllerAnimatedTransitioning?)) -> Self {
        animatedPresentation = closure
        return self
    }

    /// Asks for the transition animator object to use when dismissing a view controller.
    @discardableResult
    func animatedDismissal(_ closure: @escaping(_ dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?) -> Self {
        animatedDismissal = closure
        return self
    }

    // MARK: - Interactive Animator Objects

    private var interactivePresentation: ((_ animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)?
    private var interactiveDismissal: ((_ animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?)?

    /// Asks for the interactive animator object to use when presenting a view controller.
    @discardableResult
    func interactivePresentation(_ closure: @escaping(_ animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?) -> Self {
        interactivePresentation = closure
        return self
    }

    /// Asks for the interactive animator object to use when dismissing a view controller.
    @discardableResult
    func interactiveDismissal(_ closure: @escaping (_ animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?) -> Self {
        interactiveDismissal = closure
        return self
    }

    // MARK: - Custom Presentation Controller

    private var presentationController: ((Presentation) -> UIPresentationController?)?

    /// Asks for the custom presentation controller to use for
    /// managing the view hierarchy when presenting a view controller.
    @discardableResult
    func presentationController(_ closure: @escaping (Presentation) -> UIPresentationController?) -> Self {
        presentationController = closure
        return self
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentation = Presentation(presented: presented, presenting: presenting, source: source)
        return animatedPresentation?(presentation)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animatedDismissal?(dismissed)
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivePresentation?(animator)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveDismissal?(animator)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = Presentation(presented: presented, presenting: presenting, source: source)
        return presentationController?(presentation)
    }
}
