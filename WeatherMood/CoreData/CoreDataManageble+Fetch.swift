//
//  CoreDataManager+Fetch.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/07/27.
//

import CoreData
import Foundation

// MARK: - Fetch
extension CoreDataManageable {
    /// T타입에 해당하는 모델을 날짜순으로 정렬하여, 가장 최신순으로 fetchLimit만큼 가져온다. default로 100개이다.
    /// - Parameters:
    ///   - limit: 모델데이터 리스트 최대개수를 지정한다. default로 100개이다.
    ///   - completion: 특정 model타입의 배열을 인자로 받는 비동기 클로저며, 에러가날경우 nil을 받게되고, 없는경우는 count가 0이된다. 옵셔널바인딩이 필요하다.
    /// ```
    /// manager.fetch(limit: 1) { (diaries: [Diary]?) in
    ///     if let _ = diaries {
    /// }
    /// ```
    func fetch<T: NSManagedObject>(limit: Int = 100,
                                   _ completion: @escaping(([T]?) -> Void)) {
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        request.fetchLimit = limit
        request.fetchBatchSize = 100
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        mainContext.perform {
            let temperature: [T]? = try? request.execute()
            completion(temperature)
        }
    }
}
