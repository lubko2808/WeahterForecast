//
//  NewCityViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 21.06.2023.
//

import UIKit
import CoreLocation

class NewCityViewController: UIViewController {
    
    private let cellIdentifier = "cell"
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?
    private var matchingCities: [String] = []

    private let saveBarButton = UIBarButtonItem()
    private let cancelBarButton = UIBarButtonItem()
    private let cityTextField = RoundedTextField()
    private let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureNavigationBar()
        configureCityTextField()
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        //tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 22),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
        
    }
    
    private func configureCityTextField() {
        view.addSubview(cityTextField)
        cityTextField.delegate = self
        
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 15),
            cityTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cityTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            cityTextField.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        cityTextField.becomeFirstResponder()
        cityTextField.placeholder = "Fill into city name"
    }

    private func configureNavigationBar() {
        self.title = "Add city"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.isHidden = false
        
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 22)]
            //appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemBlue,]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        saveBarButton.title = "save"
        saveBarButton.tintColor = UIColor.systemBlue
        saveBarButton.style = .plain
        saveBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 22)], for: .normal)
        saveBarButton.target = self
        saveBarButton.action = #selector(saveCityAction)
        
        cancelBarButton.title = "cancel"
        cancelBarButton.tintColor = UIColor.systemBlue
        cancelBarButton.style = .plain
        cancelBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 22)], for: .normal)
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelAction)
        
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
    }

    @objc private func saveCityAction() {}
    
    @objc private func cancelAction() {}
    
}

extension NewCityViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let currentLatitude, let currentLongitude else {
            print("Current location is unknown")
            return
        }
        
        let geocoder = CLGeocoder()
        
        let center = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        let radius: CLLocationDistance = 50000
        let region = CLCircularRegion(center: center, radius: radius, identifier: "CityRegion")
        
        geocoder.geocodeAddressString("Lviv", in: region) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let nearbyPlacemarks = placemarks {
                for placemark in nearbyPlacemarks {
                    if let nearbyCity = placemark.locality {
                        print("Nearby city: \(nearbyCity)")
                    }
                }
            }
            
        }
    }
    
}

extension NewCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = matchingCities[indexPath.row]
        return cell
    }
}



//if let nearbyPlacemarks = placemarks {
//    // Process the nearby placemarks and filter based on city names
//    let filteredCities = nearbyPlacemarks.filter { placemark in
//        if let nearbyCity = placemark.locality {
//            // Check if the city name contains the desired letters
//            return nearbyCity.range(of: "abc", options: .caseInsensitive) != nil
//        }
//        return false
//    }
//
//    // Print the filtered city names
//    for placemark in filteredCities {
//        if let nearbyCity = placemark.locality {
//            print("Filtered city: \(nearbyCity)")
//        }
//    }
//}
