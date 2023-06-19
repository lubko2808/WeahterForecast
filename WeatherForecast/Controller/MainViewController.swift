//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 27.05.2023.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var city: City?
    
    enum Constants {
        static let cellIdentifier = "cell"
        static let numberOfDays = 5
    }

    private let tableView = UITableView()
    private let cityBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToModel()
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let city = city {
            title = city.name
            viewModel.fetchWeatherForCity(cityName: city.name)
        } else {
            title = "Current location"
        }
    }
    
    private func bindToModel() {
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
        viewModel.onResultReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func navigateToCityController() {
        let citiesTableViewController = CitiesTableViewController()
        citiesTableViewController.delegate = self
        navigationController?.pushViewController(citiesTableViewController, animated: true)
    }
    
    private func configureNavigationBar() {
        
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        cityBarButton.title = "city"
        cityBarButton.tintColor = UIColor.systemIndigo
        cityBarButton.style = .plain
        cityBarButton.target = self
        cityBarButton.action = #selector(navigateToCityController)
        
        navigationItem.leftBarButtonItem = cityBarButton
    }

    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 80
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: MainViewController.Constants.cellIdentifier)
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainViewController.Constants.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  MainViewController.Constants.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if viewModel.isDataReady {
            cell.dayLabel.text = viewModel.weather.day(at: indexPath.row)
            cell.dayAndNightTemperatureLabel.text = viewModel.weather.getDayAndNightTemperature(for: indexPath.row)
            cell.weatherImageView.image = UIImage(systemName: viewModel.weather.getWeatherType(for: indexPath.row).rawValue)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier) as! TableHeaderView
        
        if viewModel.isDataReady {
            header.currentTemperatureLabel.text = viewModel.weather.getCurrentTemperature()
            header.dayAndNightTemperatureLabel.text = viewModel.weather.getDayAndNightTemperature(for: 0)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
}

extension MainViewController: CitiesTableDelegate {
    
    func didChooseCity(_ city: City) {
        self.city = city
    }
    
}
