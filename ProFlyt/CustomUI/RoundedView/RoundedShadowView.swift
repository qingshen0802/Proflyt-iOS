//
//  RoundedShadowView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/12/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
    
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
        layer.shadowPath = UIBezierPath(rect: CGRectMake(-1, -1, self.frame.size.width + 2, self.frame.size.height + 2)).CGPath
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSizeMake(0, 0)
        self.clipsToBounds = false
    }

}
