//
//  APIRequester.swift
//  thermometer-swift
//
//  Created by Phoenix on 8/28/16.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import TSMessages

let WeatherAPIKey: String = "679bd8713697628c84115b45cfa70e2d"

class APIRequester {
    
    static func formatWeatherAPIURL(latitude: Double, longitude: Double) -> String {
        return "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=imperial&APPID=\(WeatherAPIKey)"
    }
    
    static func get(apiEndpoint: String,  params: [String:AnyObject]?,
                    successHandler:(Response<AnyObject, NSError>) -> Void,
                    errorHandler:(NSError?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, apiEndpoint, parameters: params).responseJSON { reqResponse in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if reqResponse.result.isSuccess {
                successHandler(reqResponse)
            } else {
                if reqResponse.result.error?.code == NSURLErrorNotConnectedToInternet {
                    TSMessage.showNotificationWithTitle("Error",
                        subtitle:"Internet connectivity is poor. Will retry in one minute.",
                        type:TSMessageNotificationType.Error);
                }
                errorHandler(reqResponse.result.error)
            }
        }
    }
    
    static func post(apiEndpoint: String,  params: [String:AnyObject],
                    successHandler:(Response<AnyObject, NSError>) -> Void,
                    errorHandler:(NSError?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.POST, apiEndpoint, parameters: params).responseJSON { reqResponse in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if reqResponse.result.isSuccess {
                successHandler(reqResponse)
            } else {
                if reqResponse.result.error?.code == NSURLErrorNotConnectedToInternet {
                    TSMessage.showNotificationWithTitle("Error",
                        subtitle:"Internet connectivity is poor. Will retry in one minute.",
                        type:TSMessageNotificationType.Error);
                }
                errorHandler(reqResponse.result.error)
            }
        }
    }
    
}