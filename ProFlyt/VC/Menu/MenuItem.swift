//
//  MenuItem.swift
//  ProFlyt
//
//  Created by Simon Weingand on 9/23/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit

class MenuItem: UITableViewCell {
    
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notifyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if notifyLabel.hidden == false {
            let layer = notifyLabel.layer
            layer.masksToBounds = true
            layer.cornerRadius = notifyLabel.frame.size.height / 2.0
            layer.backgroundColor = UIColor(red: 120.0 / 255.0, green: 102.0 / 255.0, blue: 136.0 / 255.0, alpha: 1).CGColor
            notifyLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func setNotify(count: Int?) {
        if count > 0 {
            notifyLabel.text = String(count!)
            notifyLabel.hidden = false
        }
        else {
            notifyLabel.text = ""
            notifyLabel.hidden = true
        }
    }

}
