//
//  WindTempService.swift
//  ProFlyt
//
//  Created by Simon Weingand on 7/28/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

// MARK: - JSON

//extension Request {
//    
//    /**
//    Creates a response serializer that returns a string initialized from the response data with the specified string encoding.
//    
//    :param: encoding The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set, ISO-8859-1.
//    
//    :returns: A string response serializer.
//    */
//    public static func windTempResponseSerializer(var encoding: NSStringEncoding? = nil) -> GenericResponseSerializer<[String: [Int: WindTemp]]> {
//        return GenericResponseSerializer { _, response, data in
//            if data == nil || data?.length == 0 {
//                return (nil, nil)
//            }
//            
//            if let encodingName = response?.textEncodingName where encoding == nil {
//                encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName))
//            }
//            
//            let string = NSString(data: data!, encoding: encoding ?? NSISOLatin1StringEncoding) as? String
////            var windTemp: [String: [Int: WindTemp]]! = WindTempParsing(data: string).windTemps
//            
////            return (windTemp, nil)
//        }
//    }
//    
//    /**
//    Adds a handler to be called once the request has finished.
//    
//    :param: encoding The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set, ISO-8859-1.
//    :param: completionHandler A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the string, if one could be created from the URL response and data, and any error produced while creating the string.
//    
//    :returns: The request.
//    */
//    public func responseWindTemp(
//        encoding: NSStringEncoding? = nil,
//        completionHandler: (NSURLRequest, NSHTTPURLResponse?, [String: [Int: WindTemp]]?, NSError?) -> Void)
//        -> Self
//    {
//        return response(
//            responseSerializer: Request.windTempResponseSerializer(encoding: encoding),
//            completionHandler: completionHandler
//        )
//    }
//}
//
//struct WindTempService {
//    enum Router: URLRequestConvertible {
//        static let baseURLString = "http://www.aviationweather.gov"
//        
//        case WindTemp(WindtempLevel, WindtempFCST)
//        
//        var URLRequest: NSURLRequest {
//            let (path: String, parameters: [String: AnyObject]) = {
//                switch self {
//                case .WindTemp(let level, let fcst):
//                    let params = ["level": "\(level.rawValue)", "fcst":"\(fcst.rawValue)", "region": "all", "layout":"off"]
//                    return ("/windtemp/data", params)
//                }
//            }()
//            
//            let URL = NSURL(string: Router.baseURLString)
//            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
//            let encoding = Alamofire.ParameterEncoding.URL
//            
//            return encoding.encode(URLRequest, parameters: parameters).0
//        }
//    }
//    
//    enum WindtempLevel: String {
//        case Low = "l"
//        case High = "h"
//    }
//    
//    enum WindtempFCST: String {
//        case fcst6 = "06"
//        case fcst12 = "12"
//        case fcst24 = "24"
//    }
//    enum WindtempRegion : String {
//        case NortheastBoston = "bos"
//        case SoutheastMiami = "mia"
//        case NorthcentralChicago = "chi"
//        case SouthcentralDallasFortWorth = "dfw"
//        case RockyMountainsSaltLakeCity = "slc"
//        case PacificCoastSanFrancisco = "sfo"
//        case Alaska = "alaska"
//        case Hawaii = "hawaii"
//        case WesternPacific = "other_pac"
//    }
//}
//
////let fts: [Int] = [8000, 10000, 15000, 18000, 21000, 24000, 27000, 30000, 33000, 36000, 39000, 42000]
//
////public class WindTempParsing {
////    
////    let lowWindTempLength = 69
////    let iataLength = 3
////    let lengths: [Int: Int] = [3000:4, 6000:7, 9000:7, 12000:7, 18000:7, 24000:7, 30000:6, 34000:6, 39000:6]
////    var windTemps: [String: [Int: WindTemp]] = [String: [Int: WindTemp]]()
////    var rawValue: AnyObject?
////    
////    init(data: String?) {
////        if data != nil {
////            rawValue = data
////            if let parser = Kanna.HTML(html: data!, encoding: NSUTF8StringEncoding) {
////                if let preText = parser.xpath("//pre").text {
////                    textToDictionary(preText)
////                }
////            }
////        }
////    }
////    
////    func textToDictionary(text: String!) {
////        var data = text!.componentsSeparatedByString("\n")
////        for airportWindTempData in data {
////            if count(airportWindTempData) == lowWindTempLength
////            {
////                var startIndex = airportWindTempData.startIndex
////                var endIndex = advance(startIndex, iataLength)
////                var iata = airportWindTempData.substringToIndex(endIndex)
////                if iata != "FT " {
////                    var windTempData : [Int:WindTemp] = [Int:WindTemp]()
////                    for index in 0..<fts.count {
////                        startIndex = advance(endIndex, 1)
////                        endIndex = advance(startIndex, lengths[fts[index]]!)
////                        windTempData[fts[index]] = WindTemp(data: airportWindTempData.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex)))
////                    }
////                    windTemps[iata] = windTempData
////                }
////            }
////        }
////    }
////}
//
//public class WindTemp {
//    var windDirection: Double!
//    var windSpeed: Double!
//    var temperature: Double!
//    
//    init(data: String?) {
//        if data != nil {
//            var startIndex = data!.startIndex
//            var endIndex = advance(startIndex, 2)
//            var str = data!.substringToIndex(endIndex)
//            windDirection = str == "  " ? nil : Double(str.toInt()! * 10)
//            startIndex = endIndex
//            endIndex = advance(startIndex, 2)
//            str = data!.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
//            windSpeed = str == "  " ? nil : Double(str.toInt()!)
//            if IS_TESTING == true
//            {
//                windDirection = 270.0
//                windSpeed = 50.0
//            }
//            if count(data!) > 4 {
//                startIndex = endIndex
//                endIndex = data!.endIndex
//                str = data!.substringFromIndex(startIndex)
//                temperature = str == "  " || str == "   " ? nil : Double(str.toInt()!)
//            }
//        }
//    }
//}