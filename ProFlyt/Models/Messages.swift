//
//  Messages.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/30/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import Foundation

class Messages {
    
    static func showMessage(title: String?, msg: String?) {
        UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: "Ok").show()
    }
}
