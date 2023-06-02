//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 27.05.2023.
//

import Foundation
import MapKit

struct WeatherManager {
    
    private func geocoder(city: String, completion: @escaping(Double, Double) -> Void) {
        let geocoder = CLGeocoder()
        
        var latitude: Double = 0
        var longitude: Double = 0
        
        geocoder.geocodeAddressString(city, completionHandler: {(placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                completion(latitude, longitude)
            }
        })
    }
    
    func fetchWeather(city: String, completion: @escaping(WeatherModel) -> Void) {
        
        geocoder(city: city) { latitude, longitude in
            fetchWeather(latitude: latitude, longitude: longitude, completion: completion)
        }
    }
        
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping(WeatherModel) -> Void) {
        
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=" + String(latitude) + "&longitude=" + String(longitude) + "&hourly=temperature_2m"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather: \(error.localizedDescription)")
                return
            }
            
            guard let jsonData = data else {
                print("No data received")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(WeatherModel.self, from: jsonData)
                completion(decodedData)
            } catch {
                print("Error decoding data: \(error)")
            }
        }
        
        dataTask.resume()
    }

}
