//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 08.06.2023.
//

import UIKit
import MapKit
import CoreLocation

class MainViewModel: NSObject {
    
    var onResultReceived: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private let locationManager = CLLocationManager()
    private var weatherModel: WeatherModel?
    private var weatherFormatter = WeatherDataFormatter()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func getCurrentTemperature() -> String? {
        guard let weatherModel else {
            return nil
        }
        return weatherFormatter.getCurrentTemperature(weatherModel)
    }
    
    func getDayAndNightTemperature(for index: Int) -> String? {
        guard let weatherModel else {
            return nil
        }
        return weatherFormatter.getDayAndNightTemperature(weatherModel, for: index)
    }
    
    func getWeatherType(for day: Int) -> WeatherDataFormatter.WeatherIcon? {
        guard let weatherModel else {
            return nil
        }
        return weatherFormatter.getWeatherType(weatherModel, for: day)
    }
    
    func day(at index: Int) -> String {
        weatherFormatter.day(at: index)
    }
    
    func fetchWeatherForCurrentLocation() {
        guard let currentLocation = locationManager.location else {
            print("Can't obtain current location")
            return
        }
        
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        
        API.Client.shared.fetch(.forecast(latitude: currentLatitude, longitude: currentLongitude)) { (result: Result<WeatherModel, API.Error>) in
            self.handleResult(result)
        }
    }
    
    func fetchWeatherForCity(cityName: String) {
        
        geocoder(city: cityName) { latitude, longitude in
            API.Client.shared.fetch(.forecast(latitude: latitude, longitude: longitude)) {
                (result: Result<WeatherModel, API.Error>) in
                self.handleResult(result)
            }
        }
    }
    
    private func handleResult<Response>(_ result: Result<Response, API.Error>) {
        
        switch result {
        case .success(let data):
            if let data = data as? WeatherModel {
                let hourly = WeatherModel.Hourly(temperature_2m: data.hourly.temperature_2m, weathercode: data.hourly.weathercode)
                weatherModel = WeatherModel(hourly: hourly)
            }
            self.onResultReceived?()
        case .failure(let failure):
            self.onError?(failure.localizedDescription)
        }
    }
    
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
}


extension MainViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchWeatherForCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}
