//
//  MainCoordinator.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 15.07.2023.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func chooseCity() {
        let citiesTableViewController = CitiesTableViewController()
        citiesTableViewController.coordinator = self
        navigationController.pushViewController(citiesTableViewController, animated: false)
    }
    
    func addCity() {
        let newCityViewController = NewCityViewController()
        newCityViewController.coordinator = self
        let navigationVC = UINavigationController(rootViewController: newCityViewController)
        navigationVC.modalTransitionStyle = .flipHorizontal
        navigationController.present(navigationVC, animated: true, completion: nil)
    }
    
    func navigateToMainController() {
        navigationController.popViewController(animated: false)
    }
    
    func navigateToMainController(with city: String? = nil) {
        guard let city else {
            navigationController.popViewController(animated: false)
            return
        }
        if let mainViewController = navigationController.viewControllers.first(where: {$0 is MainViewController}) as? MainViewController {
            mainViewController.city = city
        }
        navigationController.popViewController(animated: false)
    }
    
    func navigateToCitiesTableViewController(with city: String) {
        if let citiesTableViewController = navigationController.viewControllers.first(where: {$0 is CitiesTableViewController}) as? CitiesTableViewController {
            citiesTableViewController.createCity(cityName: city)
        }
        navigationController.dismiss(animated: true, completion: nil)
    }
    
}
