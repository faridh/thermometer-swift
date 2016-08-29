//
//  ViewController.swift
//  thermometer-swift
//
//  Created by Phoenix on 8/28/16.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import UIKit
import TSMessages
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var gradientView: UIView!
    @IBOutlet var tempMainLabel: UILabel!
    @IBOutlet var tempSecondaryLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var geoCoder: CLGeocoder?
    var currentPlacemark: CLPlacemark?
    var currentLatitude: Double
    var currentLongitude: Double
    
    required init?(coder aDecoder: NSCoder) {
        currentLatitude = 0.0
        currentLongitude = 0.0
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLocationServices()
        
        // City Name on init
        cityNameLabel?.text = "-"
        // Farenheit on init
        tempMainLabel?.text = "-460 °F"
        // Celsius on init
        tempSecondaryLabel?.text = "-273 °C"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels(temp: Temperature) {
        // Farenheit on init
        tempMainLabel.text = Temperature.formattedTemperature(temp.temperatureF) + " °F"
        // Celsius on init
        tempSecondaryLabel.text = Temperature.formattedTemperature(temp.temperatureC) + " °C"
    }
    
    func updateBackgroundColor(temp: Temperature) {
        
        let mainColor: UIColor = ViewDecorator.colorForTemperature(temp.temperatureF.integerValue)
        if let sublayers = gradientView.layer.sublayers {
            for tempLayer in sublayers {
                tempLayer.removeFromSuperlayer()
            }
        }
        
        let gradView: CAGradientLayer = ViewDecorator.gradientViewWithColors([mainColor.CGColor,
            mainColor.CGColor, UIColor.init(white: 1.0, alpha: 0.1).CGColor], frame: gradientView.frame)
        gradientView.layer.addSublayer(gradView)
        backgroundView.backgroundColor = mainColor
        self.view.layoutSubviews()
    }
    
    override func preferredStatusBarStyle() ->  UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    func setupLocationServices() {
        geoCoder = CLGeocoder()
        locationManager = CLLocationManager()
        locationManager!.delegate = self;
        locationManager!.distanceFilter = kCLDistanceFilterNone;
        locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager!.requestWhenInUseAuthorization()
    }
    
    func restartLocationManager() {
        locationManager?.stopUpdatingLocation()
        _ = NSTimer.scheduledTimerWithTimeInterval(60, target: locationManager!,
                                                   selector: #selector(CLLocationManager.startUpdatingLocation),
                                                   userInfo: nil,
                                                   repeats: false)
    }
    
    // MARK: CLLocationManagerDelegate methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations[0];
        currentLatitude = (currentLocation?.coordinate.latitude)!
        currentLongitude = (currentLocation?.coordinate.longitude)!
        
        geoCoder?.reverseGeocodeLocation(currentLocation!, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) in
            if error == nil {
                self.currentPlacemark = placemarks![0];
                let apiURL: String = APIRequester.formatWeatherAPIURL(self.currentLatitude, longitude: self.currentLongitude)
                APIRequester.get(apiURL, params: nil, successHandler: { response in
                    let temp: Temperature = Temperature(weatherModel: response)
                    self.updateLabels(temp)
                    self.updateBackgroundColor(temp)
                    self.cityNameLabel.text = temp.city
                    }, errorHandler: { error in
                        TSMessage.showNotificationWithTitle("Error",
                            subtitle:"Some error occurred. Will retry in one minute.",
                            type:TSMessageNotificationType.Error);
                })
                
            } else {
                self.restartLocationManager()
                TSMessage.showNotificationWithTitle("Error",
                    subtitle:"Some error occurred. Please check your internet connectivity.",
                    type:TSMessageNotificationType.Error);
            }

        })
        
        self.restartLocationManager()
        TSMessage.showNotificationWithTitle("Notice", subtitle: "Getting temperature information for current area.",
                                            type: TSMessageNotificationType.Message)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch (status) {
            case CLAuthorizationStatus.AuthorizedWhenInUse,
                 CLAuthorizationStatus.AuthorizedAlways:
                locationManager!.startUpdatingLocation()
                break
            case CLAuthorizationStatus.Denied,
                 CLAuthorizationStatus.Restricted,
                 CLAuthorizationStatus.NotDetermined:
                TSMessage.showNotificationWithTitle("Error",
                                                    subtitle:"Turn on location services in Settings > Privacy > Location Services in order to be able to get temperature information for your area.",
                                                    type:TSMessageNotificationType.Error)
                break
        }
    }

}

