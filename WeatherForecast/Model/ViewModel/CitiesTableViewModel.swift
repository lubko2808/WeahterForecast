//
//  CitiesTableViewModel.swift
//  WeatherForecast
//
//  Created by Lubomyr Chorniak on 28.12.2023.
//

import UIKit 
import CoreData

class CitiesTableViewModel {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var fetchResultController: NSFetchedResultsController<City>!

    public var cities: [City] = []
    
    public func fetchCities(searchText: String = "") {
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
            cities = fetchResultController.fetchedObjects ?? []
        } catch {
            print(error)
        }
    }

    public func createCity(cityName: String) {
        let newItem = City(context: context)
        newItem.name = cityName
        
        do {
            try context.save()
            fetchCities()
        } catch {
            print("createCity error")
        }
    }

    public func deleteCity(item: City) {
        context.delete(item)
        
        do {
            try context.save()
            fetchCities()
        } catch {
            print("deleteCity error")
        }
    }
    
}
