//
//  PersonTableViewCell.swift
//  SilentPushTest
//
//  Created by Daniel Hjärtström on 2019-11-28.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    private lazy var dotImageView: UIImageView = {
        let temp = UIImageView()
        temp.tintColor = UIColor.blue
        temp.image = Constants.Icons.dot
        temp.contentMode = .scaleAspectFit
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        temp.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        temp.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: customAccessoryView.leadingAnchor).isActive = true
        return temp
    }()
    
    private lazy var label: UILabel = {
        let temp = UILabel()
        temp.textColor = UIColor.black
        temp.textAlignment = .left
        temp.minimumScaleFactor = 0.7
        temp.adjustsFontSizeToFitWidth = true
        temp.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.trailingAnchor.constraint(equalTo: dotImageView.leadingAnchor, constant: -10.0).isActive = true
        temp.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        return temp
    }()
    
    private lazy var customAccessoryView: UIImageView = {
        let temp = UIImageView()
        temp.tintColor = UIColor.black
        temp.image = UIImage(systemName: "chevron.right")
        temp.contentMode = .scaleAspectFit
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        temp.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        temp.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        temp.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return temp
    }()
    
    func configure(_ person: Person) {
        customAccessoryView.isHidden = false
        label.text = person.name
        
        if person.hasBeenRead {
            dotImageView.image = nil
        } else {
            dotImageView.image = Constants.Icons.dot
        }
        
    }
    

}
