//
//  MatchingCityTableViewCell.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 22.06.2023.
//

import UIKit

class MatchingCityTableViewCell: UITableViewCell {

    let cityLabel = UILabel()
    let countryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
        
        cityLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        countryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        countryLabel.textColor = UIColor.darkGray
    
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
