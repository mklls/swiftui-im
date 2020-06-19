//
//  TimeStamp.swift
//  Alias
//
//  Created by mkll on 6/7/20.
//  Copyright © 2020 mkll. All rights reserved.
//

import Foundation


extension Date {
    var timeStamp: Int {
        Int(self.timeIntervalSince1970)
    }
    static func convert(now timeStamp: Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm"
        
        return dformatter.string(from: date)
    }
}
