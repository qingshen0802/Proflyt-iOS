//
//  RoundedView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/11/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        let layer = self.layer as CALayer
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor(red: 193.0 / 255.0, green: 196.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0).CGColor
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
