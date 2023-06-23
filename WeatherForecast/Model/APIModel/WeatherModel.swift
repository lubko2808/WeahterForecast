//
//  weatherModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 10.06.2023.
//

import Foundation

struct WeatherModel: Decodable {
    let hourly: Hourly
    
    struct Hourly: Decodable {
        let temperature_2m: [Double]
        let weathercode: [Int]
    }
}
