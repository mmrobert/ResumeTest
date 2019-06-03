//
//  ExperienceDetailController.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-06-02.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import UIKit

class ExperienceDetailController: UIViewController, UITableViewDataSource {
    
    let experienceTitle = UILabel()
    let experienceTableView = UITableView()
    
    var experienceList: [ExperienceViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        self.setExperienceTitle(textStr: "Experience")
        self.setupTableView()
    }
    
    private func setExperienceTitle(textStr: String) {
        
        experienceTitle.translatesAutoresizingMaskIntoConstraints = false
        
        experienceTitle.font = UIFont(name: "HelveticaNeue-Italic", size: 16)
        experienceTitle.textColor = UIColor.blue
        experienceTitle.textAlignment = .left
        
        let aText = NSAttributedString(string: textStr, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        experienceTitle.attributedText = aText
        
        self.view.addSubview(experienceTitle)
        
        NSLayoutConstraint.activate([experienceTitle.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: 10),
            experienceTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            experienceTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)])
    }
    
    private func setupTableView() {
        self.view.addSubview(experienceTableView)
        self.experienceTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            experienceTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            experienceTableView.topAnchor.constraint(equalTo: experienceTitle.bottomAnchor, constant: 0),
            experienceTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            experienceTableView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: 0)])
        
        experienceTableView.dataSource = self
        experienceTableView.register(ExperienceDetailTableCell.self, forCellReuseIdentifier: "expDetailCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experienceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expDetailCell", for: indexPath) as! ExperienceDetailTableCell
        
        cell.experienceI = self.experienceList[indexPath.row]
        
        return cell
    }
}
