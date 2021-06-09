//
//  BlurredImageView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/14/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class BlurredImageView: UIImageView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = UIScreen.mainScreen().bounds;
//        blurView.alpha = 0.5
        addSubview(blurView)

    }
}
