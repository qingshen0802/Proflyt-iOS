//
//  CustomTextField.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/11/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldType: Int {
    case Normal, Email, Date, DateAndTime, GooglePlacesAutoComplete, Number
}

protocol CustomTextFieldDelegate {
    func textFieldDidEndEditing(sender: AnyObject)
}

class CustomTextField: UITextField, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var mDelegate: CustomTextFieldDelegate!
    var enableEmpty: Bool = true
    var type: TextFieldType = .Normal
    var cornerRadius: CGFloat = 4.0
    var borderWidth: CGFloat = 1.0
    var borderColor: UIColor = UIColor(red: 193.0 / 255.0, green: 196.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    var datePicker: UIDatePicker! = UIDatePicker()
    var numberPicker: UIPickerView! = UIPickerView()
    var numbers: Array<Int>!
    var numberIndex: Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
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
        self.delegate = self
        self.layer.borderColor = borderColor.CGColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditing:", name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditing:", name: UITextFieldTextDidEndEditingNotification, object: self)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidEndEditingNotification, object: self)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 5)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 5)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        layer.borderWidth = borderWidth
    }
    
    func setTextFieldEnableEmpty(enable: Bool) {
        self.enableEmpty = enable
    }
    
    func setTextFieldCornerRadius(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.layer.cornerRadius = cornerRadius
    }
    
    func setTextFieldBorderColor(borderColor:UIColor) {
        self.borderColor = borderColor
        self.layer.borderColor = borderColor.CGColor
    }
    
    func setTextFieldBorderWidth(borderWidth: CGFloat) {
        self.borderWidth = borderWidth
        self.layer.borderWidth = borderWidth
    }
    
    func setTextFieldType(textFieldType: TextFieldType) {
        type = textFieldType
        if type == .DateAndTime
        {
            let dateComponent = NSDateComponents()
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            
            let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Day], fromDate: date)
            let year = components.year
            let month = components.month
            let day = components.day
            
            dateComponent.year = year
            dateComponent.month = month
            dateComponent.day = day + 1
            dateComponent.hour = 8
            dateComponent.minute = 0
            
            let minDate = calendar.dateFromComponents(dateComponent)
            
            datePicker.datePickerMode = UIDatePickerMode.DateAndTime
            datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            datePicker.minimumDate = minDate
            datePicker.minuteInterval = 15
            datePickerValueChanged(nil)
            self.inputView = datePicker
        }
        else if type == .GooglePlacesAutoComplete
        {
            
        }
        else if type == .Number
        {
            self.numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
            numberPicker = UIPickerView(frame: CGRectMake(0, 50, 100, 150))
            numberPicker.dataSource = self
            numberPicker.delegate = self
            numberPicker.showsSelectionIndicator = true
            self.inputView = numberPicker
        }
    }
    
    func setMinimumDateAndTime(var date: NSDate) {
        let now = NSDate()
        if date.compare(now) == .OrderedAscending
        {
            date = now
        }
        
        if datePicker.date.compare(date) == .OrderedAscending
        {
            datePicker.date = date
            datePickerValueChanged(nil)
        }
        datePicker.minimumDate = date
    }
    
    func setValid(valid:Bool) {
        if valid == true {
            self.layer.borderColor = borderColor.CGColor
        }
        else {
            self.layer.borderColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0).CGColor
        }
    }
    
    func checkValid() -> Bool {
        if enableEmpty == true && self.text!.isEmpty == false {
            if type == .Email {
                let emailRegEx =
                    "(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
                    "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                    "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
                    "z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
                    "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                    "9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                    "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
                
                let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                if emailTest.evaluateWithObject(self.text) == false {
                    self.setValid(false)
                    return false
                }
            }
            else if type == .DateAndTime && datePicker.date.compare(NSDate()) == .OrderedAscending {
                self.setValid(false)
                return false
            }
            self.setValid(true)
            return true
        }
        self.setValid(false)
        return false
    }
    

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if type == .GooglePlacesAutoComplete
        {
            if mDelegate  != nil
            {
                mDelegate.textFieldDidEndEditing(self)
            }
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(sender: UITextField) {
        self.layer.borderColor = borderColor.CGColor
    }
    
    func textFieldDidEndEditing(sender: UITextField) {
        self.checkValid()
        if mDelegate != nil
        {
            mDelegate.textFieldDidEndEditing(self)
        }
    }
    
    func datePickerValueChanged(sender: AnyObject!) {
        if datePicker == nil
        {
            self.text = ""
        }
        else {
            let df = NSDateFormatter()
            df.dateFormat = "dd MMM, YYYY HH:mm a"
            self.text = df.stringFromDate(datePicker.date)
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbers[row])
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = String(numbers[row])
        numberIndex = row
    }
}
