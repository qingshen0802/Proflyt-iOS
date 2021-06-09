//
//  SearchResultsTableViewCell.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/12/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import Parse

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var airplainNameLabel: UILabel!
    @IBOutlet weak var airplainImageView: RoundedImageView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var pricePerSeatLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var destinationTimeLabel: UILabel!
    @IBOutlet weak var timeDurationLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var destinationDateLabel: UILabel!
    
    var data: AnyObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(data: AircraftFlight?) {
        self.data = data!
        airplainNameLabel.text = data?.charterOperator![kCharterOperatorName] as? String
        
        AirportManager.downloadImage(data?.charterOperator![kCharterOperatorPicture] as? PFFile, block: { (image: UIImage?, error: NSError?) -> Void in
            if image != nil
            {
                self.airplainImageView.image = image
            }
            else
            {
                self.airplainImageView.image = UIImage(named: "airplain")
            }
        })
        
        timeDurationLabel.text = data?.blockTimeString
        let df: NSDateFormatter = NSDateFormatter()
        df.dateFormat = "h:mm a"
        departureTimeLabel.text = df.stringFromDate(data!.departureDateTime)
        destinationTimeLabel.text = data!.destinationDateTime == nil ? "" : df.stringFromDate(data!.destinationDateTime)
        df.dateFormat = "dd MMM, yyyy"
        departureDateLabel.text = df.stringFromDate(data!.departureDateTime)
        destinationDateLabel.text = data!.destinationDateTime == nil ? "" : df.stringFromDate(data!.destinationDateTime)
//        let totalPrice = NSString(format: "%.2f", data!.totalPrice)
//        let pricePerSeat = NSString(format: "%.2f", data!.pricePerSeat)
        
        let newTotalPrice = commaNumber(data!.totalPrice)
        let newPricePerSeat = commaNumber(data!.pricePerSeat)
        
        totalPriceLabel.text = "total $\(newTotalPrice)"
        pricePerSeatLabel.text = "$\(newPricePerSeat)/seat"
    }
    
    func commaNumber(number: Double) -> String{
        
        let beforeNumber = number
        var resultNumber: String = String()
        var numberInt: Int = Int()
        if beforeNumber % 1000 >= 100
        {
            resultNumber = NSString(format: "%.2f", beforeNumber % 1000) as String
        }
        else if beforeNumber % 1000 >= 10
        {
            resultNumber = "0" + (NSString(format: "%.2f", beforeNumber % 1000) as String) as String
        }
        else if beforeNumber % 1000 >= 0
        {
            resultNumber = "00" + (NSString(format: "%.2f", beforeNumber % 1000) as String) as String
        }
        numberInt = Int(beforeNumber - beforeNumber % 1000)
        if numberInt / 1000 > 0
        {
            while (numberInt / 1000 > 0)
            {
                if Int(numberInt / 1000) < 1000
                {
                    resultNumber = String(Int(numberInt / 1000)) + "," + resultNumber
                    numberInt = Int(numberInt / 1000)
                }
                else
                {
                    numberInt = Int(numberInt / 1000)
                    if Int(numberInt % 1000) >= 100
                    {
                        resultNumber = String(Int(numberInt % 1000)) + "," + resultNumber
                    }
                    else if Int(numberInt % 1000) >= 10
                    {
                        resultNumber = "0" + String(Int(numberInt % 1000)) + "," + resultNumber
                    }
                    else if Int(numberInt % 1000) >= 0
                    {
                        resultNumber = "00" + String(Int(numberInt % 1000)) + "," + resultNumber
                    }
                }
            }

        }
        else
        {
            return resultNumber
        }
        return resultNumber
    }
}
