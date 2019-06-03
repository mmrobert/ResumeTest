//
//  ExperienceTableCell.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-06-01.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import UIKit

class ExperienceTableCell: UITableViewCell {
    
    var experienceI: ExperienceViewModel? {
        didSet {
            roleLabel.text = experienceI?.role
            companyLabel.text = experienceI?.name
            timeLabel.text = experienceI?.time
            if let _imgUrl = experienceI?.logo {
                ResumeViewModel.getImageData(path: _imgUrl) { (data, errStr) in
                    if let _data = data {
                        self.logoImg.image = UIImage(data: _data)
                    }
                }
            }
        }
    }
    
    let logoImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(logoImg)
        NSLayoutConstraint.activate([
            logoImg.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            logoImg.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            logoImg.widthAnchor.constraint(equalToConstant: 30),
            logoImg.heightAnchor.constraint(equalToConstant: 30)])
        
        self.contentView.addSubview(roleLabel)
        NSLayoutConstraint.activate([
            roleLabel.leadingAnchor.constraint(equalTo: logoImg.trailingAnchor, constant: 8),
            roleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            roleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)])
        
        self.contentView.addSubview(companyLabel)
        NSLayoutConstraint.activate([
            companyLabel.leadingAnchor.constraint(equalTo: logoImg.trailingAnchor, constant: 8),
            companyLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 0),
            companyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)])
        
        self.contentView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: logoImg.trailingAnchor, constant: 8),
            timeLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 0),
            timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            timeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -7)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
