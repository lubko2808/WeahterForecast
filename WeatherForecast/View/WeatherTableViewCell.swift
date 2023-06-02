//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 28.05.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    let dayLabel = UILabel()
    
    let dayAndNightTemperatureLabel = UILabel()
    
    let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(dayLabel)
        addSubview(dayAndNightTemperatureLabel)
    
        dayLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        dayAndNightTemperatureLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dayAndNightTemperatureLabel.textColor = UIColor.darkGray

        dayAndNightTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            dayAndNightTemperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dayAndNightTemperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.spacing = 200
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(dayAndNightTemperatureLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
