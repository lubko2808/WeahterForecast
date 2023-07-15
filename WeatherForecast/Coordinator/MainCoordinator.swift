//
//  MainCoordinator.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 15.07.2023.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    func start() {
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController?.setViewControllers([mainViewController], animated: false)
    }
    
    func chooseCity() {
        let citiesTableViewController = CitiesTableViewController()
        citiesTableViewController.coordinator = self
        navigationController?.pushViewController(citiesTableViewController, animated: false)
    }
    
    func addCity() {
        let newCityViewController = NewCityViewController()
        newCityViewController.coordinator = self
        let navigationVC = UINavigationController(rootViewController: newCityViewController)
        navigationVC.modalTransitionStyle = .flipHorizontal
        navigationController?.present(navigationVC, animated: true, completion: nil)
    }
    
    func navigateToMainController() {
        navigationController?.popViewController(animated: false)
    }
    
    func navigateToMainController(with city: String) {
        if let mainViewController = navigationController?.viewControllers.first(where: {$0 is MainViewController}) as? MainViewController {
            mainViewController.city = city
        }
        navigationController?.popViewController(animated: false)
    }
    
    
    func navigateToCitiesTableViewController(with city: String) {
        if let newCityViewController = navigationController?.viewControllers.first(where: {$0 is CitiesTableViewController}) as? CitiesTableViewController {
            newCityViewController.createCity(cityName: city)
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
