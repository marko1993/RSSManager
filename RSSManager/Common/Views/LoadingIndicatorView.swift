//
//  LoadingIndicatorView.swift
//  RSSManager
//
//  Created by Marko Matijević on 08.12.2023..
//

import UIKit

class LoadingIndicatorView: UIView {
    var isAnimating: Bool = false
    var radius: CGFloat = 18.0
    var color: UIColor = .primaryColor
    
    public convenience init(radius: CGFloat = 18.0, color: UIColor = .primaryColor) {
        self.init()
        self.radius = radius
        self.color = color
    }
    
    func show() {
        guard !isAnimating else { return }
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setupAnimation(in: self.layer, size: CGSize(width: 2*radius, height: 2*radius))
    }
    
    func hide() {
        guard isAnimating else { return }
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    private func getScaleAnimation(duration: CFTimeInterval) -> CAKeyframeAnimation {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration
        return scaleAnimation
    }
    
    private func getOpacityAnimation(duration: CFTimeInterval) -> CAKeyframeAnimation {
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration
        return opacityAnimaton
    }
    
    private func getGroupAnimation(duration: CFTimeInterval) -> CAAnimationGroup {
        let animation = CAAnimationGroup()
        animation.animations = [getScaleAnimation(duration: duration), getOpacityAnimation(duration: duration)]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    func setupAnimation(in layer: CALayer, size: CGSize) {
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let x = (layer.bounds.size.width - size.width) / 2
        let y = (layer.bounds.size.height - size.height) / 2
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]

        for i in 0 ..< 8 {
            let circle = circleAt(angle: CGFloat(Double.pi / 4) * CGFloat(i),
                                  size: circleSize,
                                  origin: CGPoint(x: x, y: y),
                                  containerSize: size,
                                  color: color)

            let animation = getGroupAnimation(duration: duration)
            animation.beginTime = beginTime + beginTimes[i]
            circle.add(animation, forKey: "animation")
            layer.addSublayer(circle)
        }
    }
    
    func circleAt(angle: CGFloat, size: CGFloat, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CALayer {
        let radius = containerSize.width / 2 - size / 2
        let circle = layerWith(size: CGSize(width: size, height: size), color: color)
        let frame = CGRect(
            x: origin.x + radius * (cos(angle) + 1),
            y: origin.y + radius * (sin(angle) + 1),
            width: size,
            height: size)

        circle.frame = frame

        return circle
    }
    
    func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer: CAShapeLayer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()

        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        layer.fillColor = color.cgColor

        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
    
}

