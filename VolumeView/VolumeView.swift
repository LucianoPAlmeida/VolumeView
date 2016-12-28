//
//  VolumeView.swift
//  VolumeView
//
//  Created by Luciano Almeida on 28/12/16.
//  Copyright © 2016 Luciano Almeida. All rights reserved.
//

import UIKit

open class VolumeView: UIView {
    
    @IBInspectable
    var barsColor: UIColor = UIColor.gray {
        didSet{
            highlight()
        }
    }
    
    
    @IBInspectable
    var highlightedColor: UIColor = UIColor.blue {
        didSet{
            highlight()
        }
    }
    
    @IBInspectable
    var barWidth: CGFloat = 1.0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var barsSpace: CGFloat = 1.0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var maxValue: Int = 0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    
    private var bars: [CALayer] = []
    
    var value: Int = 0 {
        didSet{
            highlight()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    private func createBars(){
        removeBars()
        let calculatedBarsNumber = Int(frame.size.width/(barWidth + barsSpace))
        let numberOfBars = maxValue <= 0 ? calculatedBarsNumber : min(maxValue, calculatedBarsNumber)
        for i in 0..<numberOfBars{
            let bar : CALayer = self.bar(position: i, total: numberOfBars)
            bars.append(bar)
            layer.addSublayer(bar)
        }
    }
    
    private func bar(position: Int, total: Int) -> CALayer {
        let barLayer : CALayer = CALayer()
        barLayer.backgroundColor = barsColor.cgColor
        let increaseSize: CGFloat = (frame.size.height * 0.8)/CGFloat(total)
        barLayer.frame = CGRect(x: CGFloat(position) * (barWidth + barsSpace), y: frame.size.height - ((frame.size.height * 0.2) + (CGFloat(position)*increaseSize)), width: barWidth, height: (frame.size.height * 0.2) + (CGFloat(position)*increaseSize))
        return barLayer
    }
    
    private func removeBars(){
        bars.forEach({$0.removeFromSuperlayer()})
        bars.removeAll()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        createBars()
    }
    
    private func highlight(){
        for i in value..<bars.count {
            bars[i].backgroundColor = barsColor.cgColor
        }
        for i in 0..<value {
            bars[i].backgroundColor = highlightedColor.cgColor
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeValueForTouch(touches)
        highlight()
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeValueForTouch(touches)
        highlight()
    }
    
    private func changeValueForTouch(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let point : CGPoint = touch.location(in: self)
            value = adjustedValue(value: Int(point.x/((barWidth + barsSpace))))
        }
    }
    
    private func adjustedValue(value: Int) -> Int {
        if value < 0 {
            return 0
        }else if value >= bars.count {
            return bars.count
        }
        return value
    }
    
}

