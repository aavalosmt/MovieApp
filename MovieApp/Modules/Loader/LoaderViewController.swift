//
//  LoaderViewController.swift
//  MovieApp
//
//  Created by Aldo Antonio Martinez Avalos on 9/2/19.
//  Copyright © 2019 aavalosmt. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LoaderViewProtocol: class {
    var presenter: LoaderPresenterProtocol? { get set }
}

class LoaderViewController: BaseViewController {
    
    @IBOutlet weak var centerView: UIImageView!

    var pulseLayers = [CAShapeLayer]()
    
    private let didLoadRelay: PublishRelay<Void> = PublishRelay<Void>()

    var presenter: LoaderPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavBar(animated: false)
        createPulse(view: centerView)
        
        bindToPresenter()
    }
    
    private func bindToPresenter() {
        presenter?.didDataChange
            .emit(onNext: { _ in
                RouterAppDelegate.shared.startNavigation()
            }).disposed(by: disposeBag)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.presenter?.viewDidLoadTrigger.onNext(())
        }
    }
    
    private func createPulse(view: UIView) {
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: view.frame.size.width/2.0, y: view.frame.size.width/2.0)
            
            view.layer.insertSublayer(pulseLayer, at: 0)
            pulseLayers.append(pulseLayer)
        }
        
        view.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.animatePulse(index: 2)
                }
            }
        }
    }
    
    private func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.black.cgColor
        pulseLayers[index].fillColor = theme.colors.tmdbColor.cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 1.0
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.3
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
}

// MARK: - LoaderViewProtocol

extension LoaderViewController: LoaderViewProtocol {
    
}
