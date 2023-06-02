//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 27.05.2023.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    private let cellIdentifier = "cell"
    
    private var weather = Weather()
    
    private let locationManager = CLLocationManager()
    
    private let tableView = UITableView()
    
    private let cityBarButton = UIBarButtonItem()
    
    private var city: City?
    
    private var isHeaderVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let city = city {
            title = city.name
            fetchWeatherForCity(cityName: city.name)
        } else {
            title = "Current location"
        }
    }
    
    private func fetchWeatherForCity(cityName: String) {
        let weatherManager = WeatherManager()
        
        weatherManager.fetchWeather(city: cityName) { (weather) in
            self.weather.hourlyTemperature = weather.hourly.temperature_2m
            self.reloadTableView()
        }
        
    }
    
    private func fetchWeahterforCurrentLocation() {
        guard let currentLocation = locationManager.location else {
            print("Can't obtain current location")
            return
        }
        
        let weatherManager = WeatherManager()
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        
        weatherManager.fetchWeather(latitude: currentLatitude, longitude: currentLongitude) { (weather) in
            self.weather.hourlyTemperature = weather.hourly.temperature_2m
            self.reloadTableView()
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func navigateToCityController() {
        let citiesTableViewController = CitiesTableViewController()
        citiesTableViewController.callBack = { newCity in
            self.city = newCity
        }
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
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let margins = tableView.superview!.layoutMarginsGuide
    
        tableView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if weather.hourlyTemperature != nil {
            cell.dayLabel.text = weather.days[indexPath.row]
            cell.dayAndNightTemperatureLabel.text = String(weather.getTemperatureForFiveDays[indexPath.row].day) + "\u{00B0}C/" + String(weather.getTemperatureForFiveDays[indexPath.row].night) + "\u{00B0}C"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier) as! TableHeaderView
        
        if weather.hourlyTemperature != nil {
            header.currentTemperatureLabel.text = String(weather.CurrentTemperature) + "\u{00B0}C"
            header.dayAndNightTemperatureLabel.text = String(weather.getTemperatureForFiveDays[0].day) + "\u{00B0}C/" + String(weather.getTemperatureForFiveDays[0].night) + "\u{00B0}C"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! TableHeaderView

    }
}

extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchWeahterforCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }
}
