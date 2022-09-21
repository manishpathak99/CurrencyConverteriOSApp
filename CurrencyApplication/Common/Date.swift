//
//  Date.swift
//  CurrencyApplication
//
//  Created by Manish Pathak on 21/09/22.
//  Copyright © 2022 Manish Pathak. All rights reserved.
//

import Foundation

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var arrDates = [String]()
        for _ in 1 ... nDays {
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
}
