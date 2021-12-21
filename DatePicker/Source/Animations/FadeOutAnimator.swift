//
//  FadeOutAnimator.swift
//  DatePicker
//
//  Created by Igor Drljic on 21.12.21..
//

import UIKit

class FadeOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let transitionDuration: TimeInterval
    
    init(transitionDuration: TimeInterval = 0.3) {
        self.transitionDuration = transitionDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        fromView.alpha = 1
        containerView.addSubview(fromView)
        UIView.animate(withDuration: transitionDuration,
                       animations: {
                        fromView.alpha = 0
        },
                       completion: { _ in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(true)
        })
    }
}
