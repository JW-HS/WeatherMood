//
//  Date+Util.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/08/01.
//

import Foundation

extension Date {
    /// Date에서 *월1일로만 첫월의날짜만 가져온다.
    /// - Returns:  첫월의날짜의 옵셔널을 반환한다.
    func filteredMonth() -> Date? {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let components: DateComponents = calendar.dateComponents([.year, .month], from: self)
        let start: Date? = calendar.date(from: components)
        return start
    }
    
    /// 해당 Date의 한달 날짜개수를 반환한다.
    /// - Returns: 한달 날짜개수의 옵셔널을 반환한다.
    func numberOfDaysByMonth() -> Int? {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let range: Range<Int>? = calendar.range(of: .day, in: .month, for: self)
        return range?.count
    }

    /// 해당 Date의 한달날짜개수에서의 인덱스를 반환한다.
    /// - Returns: 인덱스의 옵셔널을 반환한다.
    ///
    /// 1일인경우 0을 반환한다.
    func indexByMonth() -> Int? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.timeZone = NSTimeZone.local
        let str: String = dateFormatter.string(from: self)
        guard let index = Int(str) else {
            return nil
        }
        return index - 1
    }
    
    /// 특정날짜만큼 지난 날짜를 반환한다.
    /// - Parameter offset: 이전, 이후 날짜만큼의 offset을 지정한다.
    /// - Returns: 지나거나 이전의 날짜의 옵셔널을 반환한다.
    ///
    /// offset이 1일경우 1일이후 날짜를 반환하고, offset이 -1인경우에 1일이전 날짜를 반환한다.
    func offsetDay(_ offset: Int) -> Date? {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let end: Date? = calendar.date(byAdding: .day, value: offset, to: calendar.startOfDay(for: self))
        return end
    }
}
