//
//  CoreDataManageble.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/07/30.
//

import CoreData
import Foundation
/// CoreDataManager가 되기위한 protocol이다.
///
/// extension으로 필요한 CRUD기능들을 구현해놓았다.
protocol CoreDataManageable {
    typealias CheckSaveCompletion = ((Result<Bool, CoreDataError>) -> Void)?
    typealias EachEmoticonCount = (smallFileName: String, count: Int)
    
    var persistentContainer: NSPersistentContainer { get set }
    var mainContext: NSManagedObjectContext { get set }
    var backgroundContext: NSManagedObjectContext { get set }
    
    var emptyTemperature: Int16 { get set }
}

extension CoreDataManageable {
    func save(_ completion: CheckSaveCompletion) {
        do {
            try self.mainContext.save()
            completion?(.success(true))
        } catch {
            completion?(.failure(.invalid))
        }
    }
}
