//
//  PassenserButton.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/11/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

protocol PassenserButtonDelegate {
    func didSelectPassenserButton(state: Bool, identifier: Int, title: String)
}

class PassenserButton: UIButton {

    var mDelegate: PassenserButtonDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, title: String, selected: Bool) {
        super.init(frame: frame)
        
        self.setTitle(title, forState: UIControlState.Normal)
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        self.applyStyle()
        
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func applyStyle() {
        self.setBackgroundImage(UIImage(named: "bg_passengers"), forState: UIControlState.Selected)
        self.setBackgroundImage(nil, forState: UIControlState.Normal);
    }
    
    func onTouchUpInside(sender: UIButton) {
        self.selected = true
        mDelegate?.didSelectPassenserButton(self.selected, identifier: self.tag, title: self.titleLabel!.text!)
    }
    
    func unselect() {
        self.selected = false;
    }
}
