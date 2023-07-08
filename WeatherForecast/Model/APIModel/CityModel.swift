//
//  CityModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 09.07.2023.
//

import Foundation

struct CityModel: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let city: String
        let country: String
    }
}
