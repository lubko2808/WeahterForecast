//
//  AppCoordinator.swift
//  WeatherForecast
//
//  Created by Lubomyr Chorniak on 28.12.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewControllerCoordinator = MainCoordinator(navigationController: navigationController)
        add(coordinator: mainViewControllerCoordinator)
        mainViewControllerCoordinator.start()
    }
    
}
