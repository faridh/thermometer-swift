//
//  Temperature.swift
//  thermometer-swift
//
//  Created by Phoenix on 8/28/16.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import Foundation
import Alamofire

class Temperature:AnyObject {
    
    var temperatureF: NSNumber
    var temperatureC: NSNumber
    var city: String
    var updatedAt: NSDate

    init() {
        city = "Unknown"
        temperatureF = NSNumber(int:-460)
        temperatureC = NSNumber(int:-273)
        updatedAt = NSDate()
    }
    
    init(weatherModel: Response<AnyObject, NSError>) {
        var city = String(weatherModel.result.value?["name"] as! String)
        if ( city.isEmpty ) {
            city = "Unknown"
        }
        self.city = city;
        
        var main: AnyObject = (weatherModel.result.value!)
        main = main["main"]!!
        let temp = main["temp"] as! NSNumber
        
        let rawFarenheit: Float =  Float(temp)
        let rawCelsius: Float = (rawFarenheit - 32) / 1.8
        let temperatureF: NSNumber = NSNumber(float: rawFarenheit)
        let temperatureC: NSNumber = NSNumber(float: rawCelsius)
        self.temperatureF = temperatureF
        self.temperatureC = temperatureC
        self.updatedAt = NSDate()
    }
    

    static func dateFormatter() -> NSDateFormatter {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.init(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }

    static func formattedTemperature(temperature: NSNumber) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.roundingMode = NSNumberFormatterRoundingMode.RoundUp
        return numberFormatter.stringFromNumber(temperature)!
    }

}