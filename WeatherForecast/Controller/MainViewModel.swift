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
    var weather = WeatherDataFormatter()
    var isDataReady = false
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
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
                self.weather.hourlyTemperature = data.hourly.temperature_2m
                self.weather.hourlyWeatherCodes = data.hourly.weathercode
            }
            isDataReady = true
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
    
