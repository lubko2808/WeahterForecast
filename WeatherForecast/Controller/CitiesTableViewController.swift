//
//  CitiesTableViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 30.05.2023.
//

import UIKit
import CoreData

class CitiesTableViewController: UITableViewController {
    
    private let cityCellIdentifier = "cityCell"
    
    private var cities: [City] = []
    
    private let searchController = UISearchController()
    
    private var fetchResultController: NSFetchedResultsController<City>!
    
    private var choosenCity: City?
    
    var callBack: ((City) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureNavigationBar()
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none

        tableView.rowHeight = 80
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: cityCellIdentifier)
        fetchCities()
        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
    }
    
    @objc private func addCity() {
        
        let addAlertController = UIAlertController(title: "add city", message: "enter the name of the city you want to add", preferredStyle: .alert)
        
        addAlertController.addTextField()
        let textField = (addAlertController.textFields?.first)!
        textField.placeholder = "name"
        
        addAlertController.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {_ in
            guard let text = textField.text, !text.isEmpty else {
                return
            }
            
            self.createCity(cityName: textField.text!)
        }))
        
        addAlertController.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        
        present(addAlertController, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier, for: indexPath) as! CityTableViewCell
        
        cell.nameLabel.text = cities[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        choosenCity = cities[indexPath.row]
        callBack(choosenCity!)
        navigationController?.popViewController(animated: true)
    }
    
    private func reloadTableView() {
        if let cities = fetchResultController.fetchedObjects {
            self.cities = cities
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let city = cities[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, sourceView, compeltionHandler in
            
            self.deleteCity(item: city)
            
            compeltionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
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

extension CitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        fetchCities(searchText: searchText)
    }
}

