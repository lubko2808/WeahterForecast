//
//  CityModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 22.06.2023.
//

import Foundation

struct CityModel: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let name: String
        let country: String
    }
}
