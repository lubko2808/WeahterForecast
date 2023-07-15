//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 15.07.2023.
//

import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController? { get set }
    
    func start()
}
