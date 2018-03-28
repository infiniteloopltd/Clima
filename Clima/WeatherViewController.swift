//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "6dc134ca74b9cfb3dbab50ebc7a31a79"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print ("Success, got the weather data")
                let weatherJson : JSON = JSON (response.result.value!)
                print(weatherJson)
                self.updateWeatherData(json: weatherJson)
            }
            else{
                print("Error! \(response.result.error ?? "error" as! Error)")
                self.cityLabel.text = "Network Error"
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON)
    {
        if (json["cod"].stringValue != "200")
        {
            print(json["message"].stringValue);
            cityLabel.text = "API Error"
            return
        }
        
        weatherDataModel.ciry = json["name"].stringValue
        weatherDataModel.temperature = Int(json["main"]["temp"].doubleValue - 273.16)
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        
        cityLabel.text = weatherDataModel.ciry
        temperatureLabel.text = String(weatherDataModel.temperature) + "°С"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("Lat = \(location.coordinate.latitude)")
            print("Lon = \(location.coordinate.longitude)")
            
            let params : [String : String] = ["lat" : String(location.coordinate.latitude),
                                              "lon" : String(location.coordinate.longitude),
                                              "appid" : APP_ID]
            
            getWeatherData(url : WEATHER_URL, parameters: params)
            
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


