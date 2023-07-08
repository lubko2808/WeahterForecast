//
//  CityTableViewCell.swift
//  WeatherForecast
//
//  Created by Любомир  Чорняк on 30.05.2023.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = .clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17))
        contentView.backgroundColor =  UIColor.gray.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        
        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        nameLabel.textColor = .white
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
