//
//  HelperFunctions.swift
//  HKBankTest
//
//  Created by boqian cheng on 2019-06-02.
//  Copyright © 2019 boqiancheng. All rights reserved.
//

import Foundation
import UIKit

class HelperFunctions {
    
    // bulleted paragraph
    static func bulletPointStr(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 15
        paragraphStyle.maximumLineHeight = 20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]
        
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let string = strings.map({ "\u{2022}\t\($0)" }).joined(separator: "\n")
        
        return NSAttributedString(string: string, attributes: stringAttributes)
    }
}

