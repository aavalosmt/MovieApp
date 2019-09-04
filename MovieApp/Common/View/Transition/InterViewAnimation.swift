//
//  InterViewAnimation.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/4/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit

protocol InterViewAnimatable {
    var targetView: UIView? { get }
    var snapshotImage: UIImage? { get set }
}

class InterViewAnimation: NSObject {
    
    var transitionDuration: TimeInterval = 0.25
    var isPresenting: Bool = false
}

extension InterViewAnimation: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
        }
        
        guard let fromTargetView = targetView(in: fromVC), let toTargetView = targetView(in: toVC) else {
            transitionContext.completeTransition(false)
            return
        }
        
        guard let fromImage = fromTargetView.caSnapshot(), let toImage = toTargetView.caSnapshot() else {
            transitionContext.completeTransition(false)
            return
        }
        
        let fromImageView = UIImageView(image: fromImage)
        fromImageView.clipsToBounds = true
        
        let toImageView = UIImageView(image: toImage)
        toImageView.clipsToBounds = true
        
        let startFrame = fromTargetView.frameIn(containerView)
        let endFrame = toTargetView.frameIn(containerView)
        
        fromImageView.frame = startFrame
        toImageView.frame = startFrame
        
        let cleanupClosure: () -> Void = {
            fromTargetView.isHidden = false
            toTargetView.isHidden = false
            fromImageView.removeFromSuperview()
            toImageView.removeFromSuperview()
        }
        
        let updateFrameClosure: () -> Void = {
            toVC.view.setNeedsLayout()
            toVC.view.layoutIfNeeded()
            
            let updatedEndFrame = toTargetView.frameIn(containerView)
            let correctedEndFrame = CGRect(origin: updatedEndFrame.origin, size: endFrame.size)
            fromImageView.frame = correctedEndFrame
            toImageView.frame = correctedEndFrame
        }
        
        let alimationBlock: (() -> Void)
        let completionBlock: ((Bool) -> Void)
        
        fromTargetView.isHidden = true
        toTargetView.isHidden = true
        
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                assertionFailure()
                return
            }
            containerView.addSubviews(toView, toImageView, fromImageView)
            toView.frame = CGRect(origin: .zero, size: containerView.bounds.size)
            toView.alpha = 0
            alimationBlock = {
                toView.alpha = 1
                fromImageView.alpha = 0
                updateFrameClosure()
            }
            completionBlock = { _ in
                let success = !transitionContext.transitionWasCancelled
                if !success {
                    toView.removeFromSuperview()
                }
                cleanupClosure()
                transitionContext.completeTransition(success)
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                assertionFailure()
                return
            }
            containerView.addSubviews(toImageView, fromImageView)
            alimationBlock = {
                fromView.alpha = 0
                fromImageView.alpha = 0
                updateFrameClosure()
            }
            completionBlock = { _ in
                let success = !transitionContext.transitionWasCancelled
                if success {
                    fromView.removeFromSuperview()
                }
                cleanupClosure()
                transitionContext.completeTransition(success)
            }
        }
        
        // TODO: Add more precise animation (i.e. Keyframe)
        if isPresenting {
            UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseIn,
                           animations: alimationBlock, completion: completionBlock)
        } else {
            UIView.animate(withDuration: transitionDuration, delay: 0, options: .curveEaseOut,
                           animations: alimationBlock, completion: completionBlock)
        }
    }
}

extension InterViewAnimation {
    
    private func targetView(in viewController: UIViewController) -> UIView? {
        if let view = (viewController as? InterViewAnimatable)?.targetView {
            return view
        }
        if let nc = viewController as? UINavigationController, let vc = nc.topViewController,
            let view = (vc as? InterViewAnimatable)?.targetView {
            return view
        }
        return nil
    }
}
