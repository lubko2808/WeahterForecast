//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 27.05.2023.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let viewModel = MainViewModel()
    var city: String?
    
    enum Constants {
        static let cellIdentifier = "cell"
        static let numberOfDays = 5
        static let lengthBetweenLabelsAndTable: CGFloat = 90
    }
    
    private let tableView = UITableView()
    private let cityBarButton = UIBarButtonItem()
    private let currentTempLabel = UILabel()
    private let dayAndNightTempLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToModel()
        configureBackground()
        configureNavigationBar()
        configureCurrentTempLabel()
        configureTableView()
        configureDayAndNightTempLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        
        if UIDevice.current.orientation.isPortrait {
            tableView.isScrollEnabled = false
        } else if UIDevice.current.orientation.isLandscape {
            tableView.isScrollEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentTempLabel.alpha = 0
        dayAndNightTempLabel.alpha = 0
        
        tableView.isHidden = true
        currentTempLabel.alpha = 0
        dayAndNightTempLabel.alpha = 0

        navigationController?.navigationBar.alpha = 0
        navigationController?.navigationBar.transform = CGAffineTransform(scaleX: 2, y: 2)
        navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -100)
        UIView.animate(withDuration: 0.7, delay: 0.4) {
            self.navigationController?.navigationBar.alpha = 1
            self.navigationController?.navigationBar.transform = .identity
        }
        
        if let city = city {
            title = city
            viewModel.fetchWeatherForCity(cityName: city)
        }
    }
    
// MARK: - UI Configuration
    
    private func configureBackground() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.6).cgColor,
            UIColor.systemIndigo.withAlphaComponent(0.5).cgColor,
        ]
        view.backgroundColor = .white
        view.layer.addSublayer(gradientLayer)
    }
    
    private func configureNavigationBar() {
        
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground()
            
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 25, weight: .medium)]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 50, weight: .semibold)]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        let cityButton = UIButton()
        cityButton.setTitle("city", for: .normal)
        cityButton.setTitleColor(.black, for: .normal)
        cityButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cityButton.frame = CGRect(x: cityButton.frame.origin.x, y: cityButton.frame.origin.y, width: 75, height: cityButton.frame.height)
        cityButton.backgroundColor = .white
        cityButton.layer.cornerRadius = 18
        cityButton.layer.masksToBounds = true
        cityButton.addTarget(self, action: #selector(navigateToCityController), for: .touchUpInside)
        cityBarButton.customView = cityButton
        navigationItem.leftBarButtonItem = cityBarButton
    }
    
    private func configureCurrentTempLabel() {
        view.addSubview(currentTempLabel)
        
        currentTempLabel.textColor = .white
        currentTempLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        
        currentTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            currentTempLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    private func configureDayAndNightTempLabel() {
        view.addSubview(dayAndNightTempLabel)
        
        dayAndNightTempLabel.textColor = .white
        dayAndNightTempLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        
        dayAndNightTempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayAndNightTempLabel.lastBaselineAnchor.constraint(equalTo: currentTempLabel.lastBaselineAnchor),
            dayAndNightTempLabel.leadingAnchor.constraint(equalTo: currentTempLabel.trailingAnchor),
            dayAndNightTempLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -Constants.lengthBetweenLabelsAndTable)
        ])
    }

    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: MainViewController.Constants.cellIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: Constants.lengthBetweenLabelsAndTable),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    

    
// MARK: - other
    
    private func bindToModel() {
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
        viewModel.onResultReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.animateLabels()
            }
        }
        viewModel.onCurrentCityReceived = { [weak self] currentCity in
            DispatchQueue.main.async {
                self?.title = currentCity
                self?.city = currentCity
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func animateLabels() {
        currentTempLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
        currentTempLabel.text = viewModel.getCurrentTemperature()
        
        dayAndNightTempLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
        dayAndNightTempLabel.text = viewModel.getDayAndNightTemperature(for: 0)
        
        UIView.animate(withDuration: 0.4) {
            self.currentTempLabel.transform = .identity
            self.dayAndNightTempLabel.transform = .identity
            
            self.currentTempLabel.alpha = 1
            self.dayAndNightTempLabel.alpha = 1
        }
    }
    
    @objc private func navigateToCityController() {
        coordinator?.chooseCity()
    }
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainViewController.Constants.numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  MainViewController.Constants.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if let dayAndNightTemp = viewModel.getDayAndNightTemperature(for: indexPath.row), let weatherType = viewModel.getWeatherType(for: indexPath.row) {
            cell.dayLabel.text = viewModel.day(at: indexPath.row)
            cell.dayAndNightTemperatureLabel.text = dayAndNightTemp
            cell.weatherImageView.image = UIImage(systemName: weatherType.rawValue)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isHidden == true { return }
        
        cell.transform = CGAffineTransform(translationX: -500, y: 0)
        UIView.animate(withDuration: 1, delay: Double(indexPath.row) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            cell.transform = .identity
        }
    }
    
}
