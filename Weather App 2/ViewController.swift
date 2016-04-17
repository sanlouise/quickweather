//
//  ViewController.swift
//  Weather App 2
//
//  Created by Sandra Adams-Hallie on Feb/28/16.
//  Copyright © 2016 Sandra Adams-Hallie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var labelUpcomingDays: UILabel!
    @IBAction func findWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    // Where to start splitting from.
                    
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    // To check whether the values can be found. Good for troubleshooting.
                    if websiteArray.count > 1 {
                        // Where to end the splitting.
                        let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        if weatherArray.count > 1 {
                            wasSuccessful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.labelUpcomingDays.text = String("3-day forecast for " +
                                self.cityTextField.text!)
                                self.resultLabel.text = weatherSummary
                                
                            })
                            
                        }
                    }
                }
            }
            
            // In case that the entered city does not exist.
            if wasSuccessful == false {
                self.resultLabel.text = ""
            }
            task.resume()
            
            } else {
                self.resultLabel.text = "Oops! Are you sure you entered a real city?"
            }
        }
}

