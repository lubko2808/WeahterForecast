//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 27.05.2023.
//

import Foundation

struct WeatherModel: Decodable {
    let hourly: Hourly
}

struct Hourly: Decodable {
    let temperature_2m: [Double]
}

