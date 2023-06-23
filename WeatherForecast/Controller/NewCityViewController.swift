//
//  NewCityViewController.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 21.06.2023.
//

import UIKit
import CoreLocation

protocol NewCityTableDelegate {
    func didChooseCity(_ city: String)
}

class NewCityViewController: UIViewController {
    
    private var timer: Timer?
    private let viewModel = NewCityTableViewModel()
    private let cellIdentifier = "cell"

    private let cancelBarButton = UIBarButtonItem()
    private let cityTextField = RoundedTextField()
    private let tableView = UITableView()
    
    var delegate: NewCityTableDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureNavigationBar()
        configureCityTextField()
        configureTableView()
        bindToModel()
    }
    
    private func bindToModel() {
        viewModel.onResultReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(MatchingCityTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
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
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

        cancelBarButton.title = "cancel"
        cancelBarButton.tintColor = UIColor.systemBlue
        cancelBarButton.style = .plain
        cancelBarButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 22)], for: .normal)
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelAction)
        
        navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true)
    }

}

extension NewCityViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        guard let cityPrefix  = textField.text else {
            return
        }
        
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            self?.viewModel.fetchCities(beginningWith: cityPrefix)
        })
        
    }
}

extension NewCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.matchingCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MatchingCityTableViewCell
        
        if viewModel.matchingCities.isEmpty == false {
            cell.cityLabel.text = viewModel.matchingCities[indexPath.row]
            cell.cityLabel.text?.append(",")
            cell.countryLabel.text = viewModel.countries[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenCity = viewModel.matchingCities[indexPath.row]
        delegate?.didChooseCity(chosenCity)
        dismiss(animated: true)
    }
}

