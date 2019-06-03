//
//  ResumeDataModel.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-05-31.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import Foundation

struct ResumeDataModel: Codable {
    
    let name: String
    let email: String?
    let telephone: String
    let summary: [String]
    let techKnowledge: Skills
    let experience: [Experience]
    
    struct Experience: Codable {
        
        let name: String
        let logo: String
        let role: String
        let time: String
        let duties: [String]
    }
    
    struct Skills: Codable {
        
        let languages: String
        let databases: String
        let technologies: String
    }
}

