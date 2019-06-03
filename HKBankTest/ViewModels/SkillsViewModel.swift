//
//  SkillsViewModel.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-06-01.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import Foundation

// for tech skills 
struct SkillsViewModel {
    
    var languages: String?
    var databases: String?
    var technologies: String?
    
    init(dataModel: ResumeDataModel.Skills) {
        self.languages = dataModel.languages
        self.databases = dataModel.databases
        self.technologies = dataModel.technologies
    }
}
