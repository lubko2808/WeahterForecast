//
//  MainViewModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 08.06.2023.
//

import UIKit
import MapKit
import CoreLocation

extension MainViewController {
    
    class ViewModel: NSObject {
        
        var onResultReceived: (() -> Void)?
        var onError: ((String) -> Void)?
        
        private let locationManager = CLLocationManager()
        var weather = Weather()
        
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
            
            API.Client.shared.fetch(.forecast(latitude: currentLatitude, longitude: currentLongitude)) { (result: Result<API.Types.Response.Weather, API.Types.Error>) in
                self.handleResult(result)
            }
        }
        
        func fetchWeatherForCity(cityName: String) {
            
            geocoder(city: cityName) { latitude, longitude in
                API.Client.shared.fetch(.forecast(latitude: latitude, longitude: longitude)) {
                    (result: Result<API.Types.Response.Weather, API.Types.Error>) in
                    self.handleResult(result)
                }
            }
        }
        
        private func handleResult<Response>(_ result: Result<Response, API.Types.Error>) {
            
            switch result {
            case .success(let data):
                if let data = data as? API.Types.Response.Weather {
                    self.weather.hourlyTemperature = data.hourly.temperature_2m
                    self.weather.hourlyWeatherCodes = data.hourly.weathercode
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
}

extension MainViewController.ViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchWeatherForCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}

extension MainViewController.ViewModel {
    
    struct Weather {
        
        enum WeatherInterpretCodes {
            static let sunny = [0, 1]
            static let partlyCloudy = [2]
            static let cloudy = [3]
            static let rain = [51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]
            static let snow = [71, 73, 75, 77, 85, 86]
            static let thunderstorm = [95, 96, 99]
        }
        
        enum WeatherType: String {
            case sunny = "sun.max.fill"
            case partlyCloudy = "cloud.sun.fill"
            case cloudy = "cloud.fill"
            case rain = "cloud.rain.fill"
            case snow = "cloud.snow.fill"
            case thunderstorm = "cloud.bolt.rain.fill"
        }

        private let degreeSing = "\u{00B0}"
        
        var hourlyTemperature: [Double]!
        
        var hourlyWeatherCodes: [Int]!
        
        func getWeatherType(for day: Int) -> WeatherType {
            var sunnyHoursCount = 0
            var partlyCloudyHoursCount = 0
            var cloudyHoursCount = 0
            
            for weatherCode in hourlyWeatherCodes[ (day * 24 + 8)...(day * 24 + 22) ] {
                if WeatherInterpretCodes.sunny.contains(weatherCode) {
                    sunnyHoursCount += 1
                }
                
                if WeatherInterpretCodes.thunderstorm.contains(weatherCode) {
                    return .thunderstorm
                }
            }
            
            for weatherCode in hourlyWeatherCodes[ (day * 24 + 8)...(day * 24 + 22) ] {
                if WeatherInterpretCodes.partlyCloudy.contains(weatherCode) {
                    partlyCloudyHoursCount += 1
                }
                
                if WeatherInterpretCodes.snow.contains(weatherCode) {
                    return .snow
                }
            }
            
            for weatherCode in hourlyWeatherCodes[ (day * 24 + 8)...(day * 24 + 22) ] {
                if WeatherInterpretCodes.cloudy.contains(weatherCode) {
                    cloudyHoursCount += 1
                }
                
                if WeatherInterpretCodes.rain.contains(weatherCode) {
                    return .rain
                }
            }
            
            if sunnyHoursCount >= partlyCloudyHoursCount + cloudyHoursCount {
                return .sunny
            } else if partlyCloudyHoursCount > cloudyHoursCount {
                return .partlyCloudy
            } else {
                return .cloudy
            }
        }
        
        
        func getCurrentTemperature() -> String {
            let currentDate = Date()
            
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: currentDate)
            
            let currentTemperature = hourlyTemperature[currentHour]
            
            return String(currentTemperature)
        }
        
        func getDayAndNightTemperature(for index: Int) -> String {
            let dayAndNightTemperature = String(hourlyTemperature[index * 24 + 2]) + degreeSing + "C/" +
                                         String(hourlyTemperature[index * 24 + 13]) + degreeSing + "C"
     
            return dayAndNightTemperature
        }
        
        func day(at index: Int) -> String {
            let dayDict = [0: "Sun", 1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sat"]
            
            let currentDate = Date()
            
            let calendar = Calendar.current
            let currentDay = calendar.component(.weekday, from: currentDate) - 1
            
            return dayDict[ (currentDay + index) % 7 ]!
        }
        
    }
}


