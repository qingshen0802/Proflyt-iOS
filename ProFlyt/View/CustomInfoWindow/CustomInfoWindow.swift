//
//  CustomInfoWindow.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/20/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {
    
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var airportICAO: UILabel!
    
    var airportDetails: AnyObject!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        bezierPathWithTriangle()
    }
    
    func bezierPathWithTriangle() -> UIBezierPath {
        let point1 = CGPointMake(self.bounds.width / 2 - 20, self.bounds.height - 35)
        let point2 = CGPointMake(point1.x + 40, point1.y)
        let point3 = CGPointMake(point1.x + 20, point1.y + 35)
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(point1)
        bezierPath.addLineToPoint(point2)
        bezierPath.addLineToPoint(point3)
        bezierPath.closePath()
        UIColor.whiteColor().colorWithAlphaComponent(0.9).setFill()
        bezierPath.fill()
        
        return bezierPath
    }
}
