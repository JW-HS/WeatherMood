//
//  Date+.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/27.
//

import Foundation

extension Date {
    static var currentDate: String {
        let date: Date = Date()
        return "\(Calendar.current.component(.year, from: date))-\(Calendar.current.component(.month, from: date))-\( Calendar.current.component(.day, from: date))"
    }
}
