//
//  CitiesTableViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 30.05.2023.
//

import UIKit
import CoreData
import CoreLocation

class CitiesTableViewController: UIViewController {
    
    static let cityCellIdentifier = "cityCell"

    private let tableView = UITableView()
    private let searchController = UISearchController()
    private let backgroundImageView = UIImageView()
    
    weak var coordinator: MainCoordinator?
    private let viewModel = CitiesTableViewModel()
    
// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        configureTableView()
        configureNavigationBar()
    }
    
// MARK: - UI Configuration
    
    private func configureBackground() {
        
        view.addSubview(backgroundImageView)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        backgroundImageView.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        viewModel.fetchCities()
        tableView.rowHeight = 80
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CitiesTableViewController.cityCellIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        let arrowConfig = UIImage.SymbolConfiguration(weight: .bold)
        let arrowImage = UIImage(systemName: "chevron.backward", withConfiguration: arrowConfig)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: arrowImage, style: .plain, target: self, action: #selector(navigateBack))
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cities..."
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    // MARK: - Naivgation
    @objc private func navigateBack() {
        coordinator?.navigateToMainController()
    }
    
    @objc private func addCity() {
        coordinator?.addCity()
    }
    
    // MARK: - Other
    public func createCity(cityName: String) {
        viewModel.createCity(cityName: cityName)
        reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CitiesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CitiesTableViewController.cityCellIdentifier, for: indexPath) as! CityTableViewCell
        cell.nameLabel.text = viewModel.cities[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.transform = CGAffineTransform(translationX: 0, y: tableView.rowHeight * 1.4)
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.transform = .identity
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        UIView.animate(withDuration: 0.125, animations: {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.125) {
                cell.transform = .identity
            } completion: { _ in
                let chosenCity = self.viewModel.cities[indexPath.row]
                self.coordinator?.navigateToMainController(with: chosenCity.name)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let city = viewModel.cities[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            self.viewModel.deleteCity(item: city)
            self.reloadTableView()
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}

extension CitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        viewModel.fetchCities(searchText: searchText)
        reloadTableView()
    }
}


