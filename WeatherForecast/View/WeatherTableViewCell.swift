//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 28.05.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    let weatherImageView = UIImageView()
    let dayLabel = UILabel()
    let dayAndNightTemperatureLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(weatherImageView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(dayAndNightTemperatureLabel)
        
        dayLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        dayAndNightTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dayAndNightTemperatureLabel.textColor = UIColor.darkGray

        dayAndNightTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor, multiplier: 1),
            
            dayLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 20),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            dayAndNightTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dayAndNightTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
