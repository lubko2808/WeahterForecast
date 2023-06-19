//
//  TableHeaderView.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 01.06.2023.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "TableHeader"
    
    let stackView = UIStackView()
    
    func configureStackView() {
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(currentTemperatureLabel)
        stackView.addArrangedSubview(dayAndNightTemperatureLabel)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 60, weight: .bold)
        return label
    } ()
    
    let dayAndNightTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .darkGray
        return label
    } ()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
