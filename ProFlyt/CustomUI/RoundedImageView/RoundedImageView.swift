//
//  RoundedImageView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/21/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

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
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.bounds.size.width / 2
    }

}
