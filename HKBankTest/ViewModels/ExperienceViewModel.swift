//
//  ExperienceViewModel.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-06-01.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import Foundation

struct ExperienceViewModel {
    
    var name: String?
    var logo: String?
    var role: String?
    var time: String?
    var duties: [String]?
    
    init(dataModel: ResumeDataModel.Experience) {
        self.name = dataModel.name
        self.logo = dataModel.logo
        self.role = dataModel.role
        self.time = dataModel.time
        self.duties = dataModel.duties
    }
}
