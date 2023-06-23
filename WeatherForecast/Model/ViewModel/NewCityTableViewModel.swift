//
//  MatchingCitiesViewModel.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 22.06.2023.
//

import Foundation

class NewCityTableViewModel {
    
    var onResultReceived: (() -> Void)?
    var onError: ((String) -> Void)?

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
