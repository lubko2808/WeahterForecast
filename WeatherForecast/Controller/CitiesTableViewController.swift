//
//  CitiesTableViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 30.05.2023.
//

import UIKit
import CoreData
import CoreLocation

protocol CitiesTableDelegate {
    func didChooseCity(_ city: String)
}

class CitiesTableViewController: UIViewController {
    
    static let cityCellIdentifier = "cityCell"

    private let tableView = UITableView()
    private let searchController = UISearchController()
    private let backgroundImageView = UIImageView()
    
    private var cities: [City] = []
    private var fetchResultController: NSFetchedResultsController<City>!
    var delegate: CitiesTableDelegate?
    
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

        tableView.rowHeight = 80
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CitiesTableViewController.cityCellIdentifier)
        fetchCities()
        
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
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search cities..."
        searchController.searchBar.backgroundImage = UIImage()
    }
    
// MARK: - Other
    
    @objc private func addCity() {
        let destinationViewController = NewCityViewController()
        destinationViewController.delegate = self
        let navigationVC = UINavigationController(rootViewController: destinationViewController)
        navigationVC.modalTransitionStyle = .flipHorizontal
        present(navigationVC, animated: true, completion: nil)
    }
    
    private func reloadTableView() {
        if let cities = fetchResultController.fetchedObjects {
            self.cities = cities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
// MARK: - Core Data
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func fetchCities(searchText: String = "") {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        
        if !searchText.isEmpty {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
            fetchRequest.predicate = predicate
        }
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchResultController.performFetch()
            reloadTableView()
        } catch {
            print(error)
        }
    }

    private func createCity(cityName: String) {
        let newItem = City(context: context)
        newItem.name = cityName
        
        do {
            try context.save()
            fetchCities()
        } catch {
            print("createCity error")
        }
    }

    private func deleteCity(item: City) {
        context.delete(item)
        
        do {
            try context.save()
            fetchCities()
        } catch {
            print("deleteCity error")
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CitiesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CitiesTableViewController.cityCellIdentifier, for: indexPath) as! CityTableViewCell
        cell.nameLabel.text = cities[indexPath.row].name
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
        let chosenCity = cities[indexPath.row]
        delegate?.didChooseCity(chosenCity.name)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let city = cities[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, completionHandler in
            self.deleteCity(item: city)
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
        
        fetchCities(searchText: searchText)
    }
}

extension CitiesTableViewController: NewCityTableDelegate {
    
    func didChooseCity(_ city: String) {
        self.createCity(cityName: city)
    }
}
