//
//  FadeInAnimator.swift
//  DatePicker
//
//  Created by Igor Drljic on 21.12.21..
//

import UIKit

class FadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let transitionDuration: TimeInterval
    
    init(transitionDuration: TimeInterval = 0.3) {
        self.transitionDuration = transitionDuration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        toView.alpha = 0
        containerView.addSubview(toView)
        UIView.animate(withDuration: transitionDuration,
                       animations: {
                        toView.alpha = 1
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        })
    }
}
