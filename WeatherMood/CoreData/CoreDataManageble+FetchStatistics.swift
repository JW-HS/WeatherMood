//
//  CoreDataManager+FetchStatistics.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/07/31.
//
import CoreData
import Foundation
//TODO: ⚠️수정 및 추가예정
extension CoreDataManageble {
    /// 특정`target`날짜로부터 1주일전까지 diary들을 가져온다.
    /// - Parameters:
    ///   - target: 특정 날짜지정
    ///   - interval: 7일전 또는 한달전
    ///   - completion: Diary모델 배열을 인자로받는 비동기 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요함.
    /// ```
    /// manager.fetchPreviousWeekOfMonthDiaries(from: currentDate) { diaries in
    /// }
    /// ```
    /// Calendar.startDaOfDay( Date() ) 하게되면 오늘날짜 새벽0시로된다. 내부적으로 +1을함으로써, 오늘날짜도 포함하게했다. 그러므로, 특정날짜를 고민하지않고 편하게넣는다.
    func fetchPreviousWeekOfMonthDiaries(from target: Date,
                                         _ completion: @escaping(([Diary]?) -> Void)) {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        guard let end = calendar.date(byAdding: .day, value: +1, to: calendar.startOfDay(for: target)) else {
            completion(nil)
            return
        }
        guard let start = calendar.date(byAdding: .weekOfMonth, value: -1, to: end) else {
            completion(nil)
            return
        }
        
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as NSDate, end as NSDate)
        request.predicate = predicate
        request.fetchLimit = 30
        
        mainContext.perform {
            let list: [Diary]? = try? request.execute()
            completion(list)
        }
    }
    
    /// 특정날짜에 속한 한달Diary들을 가져온다.
    /// - Parameters:
    ///   - target: 가져오고자하는 달에 해당하는 어떤날짜든 상관없는 Date
    ///   - completion: Diary모델 배열을 인자로받는 비동기 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요하다.
    func fetchMonthDiaries(startMonth target: Date,
                           _ completion: @escaping(([Diary]?) -> Void)) {
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let components: DateComponents = calendar.dateComponents([.year, .month], from: target)
        guard let start = calendar.date(from: components) else {
            completion(nil)
            return
        }
        guard let end = calendar.date(byAdding: .month, value: +1, to: calendar.startOfDay(for: start)) else {
            completion(nil)
            return
        }
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "date BETWEEN {%@, %@}", start as NSDate, end as NSDate)
        request.predicate = predicate
        request.fetchLimit = 50
        
        mainContext.perform {
            let list: [Diary]? = try? request.execute()
            completion(list)
        }
    }
}
