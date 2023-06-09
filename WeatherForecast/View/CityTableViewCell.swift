//
//  CityTableViewCell.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 30.05.2023.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        
        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
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
