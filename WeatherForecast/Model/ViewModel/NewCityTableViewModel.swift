//
//  NewCityTableViewModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 09.07.2023.
//

import Foundation


class NewCityTableViewModel {
    
    var onResultReceived: (() -> Void)?
    var onError: ((String) -> Void)?

    var cityModel: CityModel?
    var matchingCities: [String] = []
    var countries: [String] = []
    
    func fetchCities(beginningWith prefix: String) {
        
        API.Client.shared.fetch(API.Endpoint.city(prefix: prefix)) {
            (result: Result<CityModel, API.Error>) in

            self.matchingCities = []
            self.countries = []

            switch result {
            case .success(let data):
                let cityModel = data as CityModel
                for cityData in cityModel.data {
                    self.matchingCities.append(cityData.city)
                    self.countries.append(cityData.country)
                }
                self.onResultReceived?()
            case .failure(let failure):
                self.onError?(failure.localizedDescription)
            }
        }
        
    }
}

