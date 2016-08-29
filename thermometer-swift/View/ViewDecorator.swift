//
//  ViewDecorator.swift
//  thermometer-swift
//
//  Created by Phoenix on 8/28/16.
//  Copyright © 2016 Phoenix. All rights reserved.
//

import Foundation
import UIKit


class ViewDecorator {
    
    static let sharedInstance = ViewDecorator()
    
    static func gradientViewWithColors(colors: [CGColor], frame: CGRect) -> CAGradientLayer {
        let view = UIView();
        view.frame = frame;
        let gradient = CAGradientLayer.init()
        gradient.frame = view.bounds;
        gradient.colors = colors;
        return gradient;
    }
    
    /**
     * Temperature must be in Farenheit
     */
    static func colorForTemperature(temperature: Int) -> UIColor {
        if ( temperature >= 100 ) {
            return UIColor.wineColor()
        } else if ( temperature >= 90 && temperature <= 99 ) {
            return UIColor.raspberryRedColor()
        } else if ( temperature >= 80 && temperature <= 89 ) {
            return UIColor.brickColor()
        } else if ( temperature >= 70 && temperature <= 79 ) {
            return UIColor.goldenPoppyColor()
        } else if ( temperature >= 60 && temperature <= 69 ) {
            return UIColor.patinaColor()
        } else if ( temperature >= 50 && temperature <= 59 ) {
            return UIColor.brightOliveColor()
        } else if ( temperature >= 40 && temperature <= 49 ) {
            return UIColor.jadeColor()
        } else if ( temperature >= 30 && temperature <= 39 ) {
            return UIColor.lapisColor()
        } else if ( temperature >= 20 && temperature <= 29 ) {
            return UIColor.midnightBlueColor()
        } else if ( temperature >= 10 && temperature <= 19 ) {
            return UIColor.musselShellColor()
        } else if ( temperature >= 0 && temperature <= 9 ) {
            return UIColor.hydrangeaColor()
        } else if ( temperature < 0 ) {
            return UIColor.bleachColor()
        } else {
            return UIColor.bleachColor()
        }
    }
    
    /**
     * Creates a new rectangle with the size of *bounds and filled with *color
     * @return a new image
     * @param color - The UIColor that will fill our new image
     * @param bounds - The bounding size for our new image
     */
    static func imageWithColor(color: UIColor,  bounds: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds, true, 0);
        color.setFill()
        UIRectFill(CGRectMake(0, 0, bounds.width, bounds.height));
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
}