//
//  WeatherUtilities.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 28.05.2023.
//

import Foundation

struct Weather {
    
    var hourlyTemperature: [Double]!
    
    var CurrentTemperature: Double {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentDate)
        
        let currentTemperature = hourlyTemperature[currentHour]
        
        return currentTemperature
    }
    
    var getTemperatureForFiveDays: [(night: Double, day: Double)] {
        get {
            var temp: [(night: Double, day: Double)] = Array()
            
            for i in 0..<5 {
                temp.append( (night: hourlyTemperature[i * 24 + 1], day: hourlyTemperature[i * 24 + 13]) )
            }
            
            return temp
        }
    }
    
    var days: [String] {
        get {
            let dayDict = [0: "Sun", 1: "Mon", 2: "Tue", 3: "Wed", 4: "Thu", 5: "Fri", 6: "Sun"]
            var temp: [String] = Array()
            
            let currentDate = Date()
            
            let calendar = Calendar.current
            var day = calendar.component(.weekday, from: currentDate) - 1
            
            for _ in 1...5 {
                temp.append( dayDict[day % 7]! )
                day += 1
            }
            
            return temp
        }
    }
}
