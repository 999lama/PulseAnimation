//
//  PulseAnimation.swift
//  PulseAnimation
//
//  Created by Lama Albadri on 19/05/2021.
//


import UIKit

class PulseAnimation : CALayer{
    
    var animationGroup = CAAnimationGroup()
    var animationDuration : TimeInterval = 0.5
    var radius : CGFloat = 200
    var numberOfPluses : Float = 10
    
    override init(layer : Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(numberOfPluses: Float = 10 , radius : CGFloat, position: CGPoint) {
        super.init()
        self.backgroundColor = UIColor.blue.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPluses = numberOfPluses
        self.position = position
        self.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: .default).async {
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    

    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    func createOpcityAnimation() -> CAKeyframeAnimation{
        let opcictyAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opcictyAnimation.duration = animationDuration
        opcictyAnimation.keyTimes = [0 , 0.3 , 1]
        opcictyAnimation.values = [0.4, 0.8, 0]
        return opcictyAnimation
    }
    
    func setupAnimationGroup(){
        self.animationGroup.duration = animationDuration
        self.animationGroup.repeatCount = numberOfPluses
        let defaultCurve = CAMediaTimingFunction(name: .default)
        self.animationGroup.timingFunction = defaultCurve
        // set up animation group
        self.animationGroup.animations = [scaleAnimation(), createOpcityAnimation()]
    }
}
