//
//  CoreDataManager.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/07/22.
//

import CoreData
import Foundation
import UIKit

enum CoreDataError: Error {
    case invalid
}

/// CoreData model들을 CRUD기능으로 구현한 싱글톤객체다.
///
/// ⚠️기본적으로 모든 기능들은 비동기클로저를 받는다. 항상 에러핸들링 또는 옵셔널바인딩이 필요하다.
///
/// 주로 Create, Update, Delete는 에러핸들링이 필요하고, Read는 옵셔널바인딩이 필요하다.
/// ```
/// let manager = CoreDatManager.shared
/// ```
final class CoreDataManager: CoreDataManageable {
    static let shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = NSPersistentContainer(name: "WeatherMood")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error: NSError = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var mainContext: NSManagedObjectContext = persistentContainer.viewContext 
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    
    var emptyTemperature: Int16 = 9_999
    private init() { }
}
