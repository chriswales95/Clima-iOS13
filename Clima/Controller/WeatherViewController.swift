//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var delegate: WeatherManagerDelegate?
    var weatherManager = WeatherManager()
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTextField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func locationButtonPress(_ sender: Any) {
        locationManager.requestLocation()

    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        searchBarTextField.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBarTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        searchBarTextField.endEditing(true)
 
        if let location = searchBarTextField.text {
            weatherManager.fetchWeather(location)
        }
        return true
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image  = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latAndLon = (location.coordinate.latitude, location.coordinate.longitude)
            weatherManager.fetchWeather(lat: latAndLon.0, lon: latAndLon.1)
        }
    }
}
