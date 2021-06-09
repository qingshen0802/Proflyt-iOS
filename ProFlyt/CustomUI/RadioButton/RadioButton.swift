//
//  RadioButton.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/15/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

protocol RadioButtonDelegate {
    func didSelectRadioButton(identifier: Int, title: String)
}

class RadioButton: UIButton {

    @IBOutlet var delegate: AnyObject?
    
    var mDelegate: RadioButtonDelegate? {
        return delegate as? RadioButtonDelegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    init(frame: CGRect, title: String, selected: Bool) {
        super.init(frame: frame);
        
        self.setTitle(title, forState: UIControlState.Normal)
        self.initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        self.adjustEdgeInsets()
        self.applyStyle()
        
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func adjustEdgeInsets() {
        let lLeftInset: CGFloat = 8.0
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, lLeftInset, 0.0 as CGFloat, 0.0 as CGFloat)
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, (lLeftInset * 2), 0.0 as CGFloat, 0.0 as CGFloat)
    }
    
    func applyStyle() {
        self.setImage(UIImage(named: "checked_checkbox"), forState: UIControlState.Selected)
        self.setImage(UIImage(named: "unchecked_checkbox"), forState: UIControlState.Normal)
    }
    
    func onTouchUpInside(sender: UIButton) {
        if self.selected == false
        {
            self.selected = true
            mDelegate?.didSelectRadioButton(self.tag, title: self.titleLabel!.text!)
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
