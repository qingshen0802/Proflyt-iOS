//
//  CustomNavigationView.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/14/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

@objc protocol CustomNavigationViewDelegate : NSObjectProtocol {
    optional func onTouchLeftButton()
    optional func onTouchRightButton()
}

@IBDesignable class CustomNavigationView: UIView {

    var view: UIView!

    @IBOutlet var delegate: AnyObject?
    
    var mDeleage: CustomNavigationViewDelegate! {
        return delegate as! CustomNavigationViewDelegate
    }
    // Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBAction func onTouchUpLeftButton(sender: AnyObject) {
        mDeleage!.onTouchLeftButton!()
    }
    
    @IBAction func onTouchUpRightButton(sender: AnyObject) {
        mDeleage!.onTouchRightButton!()
    }
    
    @IBInspectable var leftButtonTitle: String = "" {
        didSet {
            self.leftButton.setTitle(leftButtonTitle as String, forState: .Normal)
        }
    }
    
    @IBInspectable var rightButtonTitle: String = "" {
        didSet {
            self.rightButton.setTitle(rightButtonTitle as String, forState: .Normal)
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            self.titleLabel.text = title as String
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CustomNavigationView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    

}
