//
//  ViewController.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-05-31.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // the reference to view model
    let viewModel = ResumeViewModel()
    
    // the experience list to display in table view
    private var expList: [ExperienceViewModel] = []
    
    private var boundaryView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.setBoundary()
        
        self.viewModelBinding()
        self.viewModel.getResume()
        
        
    }
    
    private func setBoundary() {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: 0)])
        
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bv)
        NSLayoutConstraint.activate([
            bv.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            bv.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            bv.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            bv.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            bv.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1)])
        self.boundaryView = bv
    }
    
    // binding view and view model
    // get back result through property observer
    private func viewModelBinding() {
        viewModel.bind(listener: { listUpdated in
            if listUpdated {
                self.expList = self.viewModel.experience
                self.setupView()
            }
        })
        viewModel.bindError(listener: { err in
            self.presentAlert(aTitle: nil, withMsg: err, confirmTitle: "OK")
        })
    }
    
    private func setupView() {
        
        let nameLabel = self.labelCenter(boldFace: true, fontSize: 25, textStr: self.viewModel.name)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.boundaryView.topAnchor, constant: 20)])
        let teleLabel = self.labelCenter(boldFace: false, fontSize: 12, textStr: self.viewModel.telephone)
        NSLayoutConstraint.activate([
            teleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1)])
        let emailLabel = self.labelCenter(boldFace: false, fontSize: 12, textStr: self.viewModel.email)
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: teleLabel.bottomAnchor, constant: 1)])
        
        let summary = self.titleLabel(textStr: "Summary")
        NSLayoutConstraint.activate([
            summary.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5)])
        let summaryDetail = self.summaryCreation(fontSize: 12, strArr: self.viewModel.summary)
        NSLayoutConstraint.activate([
            summaryDetail.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 5)])
        
        let techTitle = self.titleLabel(textStr: "Technical Skills")
        NSLayoutConstraint.activate([
            techTitle.topAnchor.constraint(equalTo: summaryDetail.bottomAnchor, constant: 5)])
        
        // use stackview display tech skills
        let stv =  self.skillsStackView()
        NSLayoutConstraint.activate([
            stv.topAnchor.constraint(equalTo: techTitle.bottomAnchor, constant: 1)])
        
      // experience title label and table
        let expTitle = self.titleLabel(textStr: "Experience")
        NSLayoutConstraint.activate([
            expTitle.topAnchor.constraint(equalTo: stv.bottomAnchor, constant: 5)])
        let expTable = self.experienceTable()
        let tableHeight = self.calculateTableHeight(tableView: expTable)
        NSLayoutConstraint.activate([
            expTable.topAnchor.constraint(equalTo: expTitle.bottomAnchor, constant: 5), expTable.bottomAnchor.constraint(equalTo: self.boundaryView.bottomAnchor, constant: -5),
            expTable.heightAnchor.constraint(equalToConstant: tableHeight)])
    }
    
    //create a label in center of view
    private func labelCenter(boldFace: Bool, fontSize: CGFloat, textStr: String?) -> UILabel {
        let aLabel = UILabel()
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        if boldFace {
            aLabel.font = UIFont(name: "HelveticaNeue-Bold", size: fontSize)
        } else {
            aLabel.font = UIFont(name: "HelveticaNeue", size: fontSize)
        }
        aLabel.textColor = UIColor.black
        aLabel.lineBreakMode = .byWordWrapping
        aLabel.textAlignment = .center
        aLabel.text = textStr
        aLabel.numberOfLines = 0
        
        self.boundaryView.addSubview(aLabel)
        
        NSLayoutConstraint.activate([
            aLabel.leadingAnchor.constraint(equalTo: self.boundaryView.leadingAnchor, constant: 10),
            aLabel.trailingAnchor.constraint(equalTo: self.boundaryView.trailingAnchor, constant: -10)])
        return aLabel
    }
    
    // create a label for title with underline, and italic
    private func titleLabel(textStr: String) -> UILabel {
        let aLabel = UILabel()
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        
        aLabel.font = UIFont(name: "HelveticaNeue-Italic", size: 16)
        aLabel.textColor = UIColor.blue
        aLabel.lineBreakMode = .byWordWrapping
        aLabel.textAlignment = .left
        
        let aText = NSAttributedString(string: textStr, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        aLabel.attributedText = aText
        
        self.boundaryView.addSubview(aLabel)
        
        NSLayoutConstraint.activate([
            aLabel.leadingAnchor.constraint(equalTo: self.boundaryView.leadingAnchor, constant: 10),
            aLabel.trailingAnchor.constraint(equalTo: self.boundaryView.trailingAnchor, constant: -10)])
        return aLabel
    }
    
    // bulleted summary
    private func summaryCreation(fontSize: CGFloat, strArr: [String]) -> UILabel {
        let aLabel = UILabel()
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        aLabel.font = UIFont(name: "HelveticaNeue", size: fontSize)
        aLabel.textColor = UIColor.black
        aLabel.lineBreakMode = .byWordWrapping
        aLabel.numberOfLines = 0
        let aStr = HelperFunctions.bulletPointStr(strings: strArr)
        aLabel.attributedText = aStr
        
        self.boundaryView.addSubview(aLabel)
        
        NSLayoutConstraint.activate([
            aLabel.leadingAnchor.constraint(equalTo: self.boundaryView.leadingAnchor, constant: 20),
            aLabel.trailingAnchor.constraint(equalTo: self.boundaryView.trailingAnchor, constant: -20)])
        return aLabel
    }
    
    private func skillsStackView() -> UIStackView {
        let skill1 = skillView(skillTitle: "Languages", skill: self.viewModel.techKnowledge?.languages)
        let skill2 = skillView(skillTitle: "Databases", skill: self.viewModel.techKnowledge?.databases)
        let skill3 = skillView(skillTitle: "Technologies", skill: self.viewModel.techKnowledge?.technologies)
        
        let stackV = UIStackView(arrangedSubviews: [skill1, skill2, skill3])
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.axis = .vertical
        stackV.spacing = 0
        stackV.distribution = .fillProportionally
        
        self.view.addSubview(stackV)
        
        NSLayoutConstraint.activate([
            stackV.leadingAnchor.constraint(equalTo: self.boundaryView.leadingAnchor, constant: 10),
            stackV.trailingAnchor.constraint(equalTo: self.boundaryView.trailingAnchor, constant: -10)])
        
        return stackV
    }
    
    private func skillView(skillTitle: String, skill: String?) -> UIView {
        let returnedView = UIView()
        returnedView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        titleLbl.textColor = UIColor.black
        titleLbl.textAlignment = .right
        titleLbl.lineBreakMode = .byWordWrapping
        titleLbl.text = skillTitle
        
        returnedView.addSubview(titleLbl)
        
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 10),
            titleLbl.topAnchor.constraint(equalTo: returnedView.topAnchor, constant: 5),
            titleLbl.widthAnchor.constraint(equalToConstant: 85)])
        
        let skillLbl = UILabel()
        skillLbl.translatesAutoresizingMaskIntoConstraints = false
        skillLbl.font = UIFont(name: "HelveticaNeue", size: 12)
        skillLbl.textColor = UIColor.black
        skillLbl.lineBreakMode = .byWordWrapping
        skillLbl.text = skill
        skillLbl.numberOfLines = 0
        
        returnedView.addSubview(skillLbl)
        
        NSLayoutConstraint.activate([
            skillLbl.leadingAnchor.constraint(equalTo: titleLbl.trailingAnchor, constant: 10),
            skillLbl.topAnchor.constraint(equalTo: returnedView.topAnchor, constant: 5),
            skillLbl.trailingAnchor.constraint(equalTo: returnedView.trailingAnchor, constant: -10),
            skillLbl.bottomAnchor.constraint(equalTo: returnedView.bottomAnchor, constant: -5)])
        
        return returnedView
    }
    
    private func experienceTable() -> UITableView {
        let aTable = UITableView()
        aTable.translatesAutoresizingMaskIntoConstraints = false
        aTable.isScrollEnabled = false
        aTable.dataSource = self
        aTable.delegate = self
        aTable.register(ExperienceTableCell.self, forCellReuseIdentifier: "expCell")
        
        self.boundaryView.addSubview(aTable)
        
        NSLayoutConstraint.activate([
            aTable.leadingAnchor.constraint(equalTo: self.boundaryView.leadingAnchor, constant: 0),
            aTable.trailingAnchor.constraint(equalTo: self.boundaryView.trailingAnchor, constant: 0)])
        return aTable
    }
    
    // dynamic calculate the table height
    private func calculateTableHeight(tableView: UITableView) -> CGFloat {
        
        var height: CGFloat = 0
        
        let noOfSec = tableView.numberOfSections
        if noOfSec > 0 {
            for j in 0..<noOfSec {
                let noOfRow = tableView.numberOfRows(inSection: j)
                if noOfRow > 0 {
                    for i in 0..<noOfRow {
                        let rowRect = tableView.rectForRow(at: IndexPath(row: i, section: j))
                        let cellHeight = rowRect.size.height
                        height = height + cellHeight
                    }
                }
            }
        }
        return height + 5
    }
    
    private func presentAlert(aTitle: String?, withMsg: String?, confirmTitle: String?) {
        
        let alert = UIAlertController(title: aTitle, message: withMsg, preferredStyle: .alert)
        let acts = UIAlertAction(title: confirmTitle, style: .default, handler: nil)
        alert.addAction(acts)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expCell", for: indexPath) as! ExperienceTableCell
        
        cell.experienceI = self.expList[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailC = ExperienceDetailController()
        detailC.experienceList = self.expList
        self.navigationController?.pushViewController(detailC, animated: true)
    }
}

