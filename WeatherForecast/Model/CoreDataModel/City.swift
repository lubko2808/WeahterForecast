//
//  City.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 30.05.2023.
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }
    
    @NSManaged public var name: String
}

extension City: Identifiable {
    
}
