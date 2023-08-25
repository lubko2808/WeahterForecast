//
//  MatchingCityTableViewCell.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 09.07.2023.
//

import Foundation

import UIKit

class MatchingCityTableViewCell: UITableViewCell {

    let cityLabel = UILabel()
    let countryLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17))
        contentView.backgroundColor =  UIColor.purple.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cityLabel)
        contentView.addSubview(countryLabel)
        
        cityLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        cityLabel.textColor = .white
        countryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        countryLabel.textColor = UIColor.lightText
    
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            cityLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        ])
//        NSLayoutConstraint.activate([
//            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//
//            countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            countryLabel.leadingAnchor.constraint(equalTo: cityLabel.trailingAnchor, constant: 5)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
