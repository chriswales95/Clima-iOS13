//
//  WeatherManager.swift
//  Clima
//
//  Created by Christopher Wales on 01/01/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
// Protocols are cool
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    /// JSON fetch
    func fetchWeather(_ location: String){
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(location)&units=metric&appid=cfb27a66c8396c8f5f711a9a5c66d793"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, url, err) in
                
                if err != nil {
                    self.delegate?.didFailWithError(error: err!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.decodeWeather(json: safeData){
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=cfb27a66c8396c8f5f711a9a5c66d793&lat=\(lat)&lon=\(lon)"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, url, err) in
                
                if err != nil {
                    self.delegate?.didFailWithError(error: err!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.decodeWeather(json: safeData){
                        self.delegate?.didUpdateWeather(weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func performRequest(url: String){
        
    }
    
    func decodeWeather(json: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: json)
            let weather = WeatherModel(conditionId: decodedData.weather[0].id, cityName: decodedData.name, temperature: decodedData.main.temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
