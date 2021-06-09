//
//  CustomInfoWindowBackgroundView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/20/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class CustomInfoWindowBackgroundView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        layer.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9).CGColor
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = bezierPathWithTriangle().CGPath
        triangleLayer.fillColor = UIColor.whiteColor().colorWithAlphaComponent(0.9).CGColor
        layer.addSublayer(triangleLayer)
        
        layer.shadowPath = UIBezierPath(rect: CGRectMake(-1, -1, self.frame.size.width + 2, self.frame.size.height + 2)).CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSizeMake(0, 0)
        
        self.clipsToBounds = false
    }
    
    func bezierPathWithTriangle() -> UIBezierPath {
        let point1 = CGPointMake(self.bounds.width / 2 - 9, self.bounds.height)
        let point2 = CGPointMake(point1.x + 18, point1.y)
        let point3 = CGPointMake(point1.x + 9, point1.y + 15)
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(point1)
        bezierPath.addLineToPoint(point2)
        bezierPath.addLineToPoint(point3)
        bezierPath.closePath()
        
        return bezierPath
    }

}
