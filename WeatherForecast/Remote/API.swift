//
//  APITypes.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 08.06.2023.
//

import Foundation

enum API {
    
    enum Error: LocalizedError {
        case generic(reason: String)
        case `internal`(reason: String)
        
        var errorDescription: String? {
            switch self {
            case .generic(let reason):
                return reason
            case .internal(let reason):
                return "Internal Error: \(reason)"
            }
        }
    }
    
    enum Endpoint {
        case forecast(latitude: Double, longitude: Double)
        case city(prefix: String)
        
        var url: URL {
            var components = URLComponents()
            
            switch self {
            case .forecast(let latitude, let longitude):
                components.scheme = "https"
                components.host = "api.open-meteo.com"
                components.path = "/v1/forecast"
                components.queryItems = [
                    URLQueryItem(name: "latitude", value: String(latitude)),
                    URLQueryItem(name: "longitude", value: String(longitude)),
                    URLQueryItem(name: "hourly", value: "temperature_2m"),
                    URLQueryItem(name: "hourly", value: "weathercode"),
                ]
            case .city(let prefix):
                components.scheme = "https"
                components.host = "geodb-cities-api.wirefreethought.com"
                components.path = "/v1/geo/cities"
                components.queryItems = [
                    URLQueryItem(name: "namePrefix", value: prefix),
                    URLQueryItem(name: "minPopulation", value: "100000"),
                ]
            }
            
            return components.url!
        }
    }
}

