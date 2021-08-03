//
//  CoreDataMock.swift
//  WeatherMoodTests
//
//  Created by hyunsu on 2021/07/30.
//

import Foundation
@testable import WeatherMood
import CoreData

final class MockCoreDataManager: CoreDataManageable {
    static let shared: MockCoreDataManager = MockCoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherMood")
        let description = container.persistentStoreDescriptions.first!
        description.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let _ = error as NSError? {
                print("fail")
            }
        })
        return container
    }()
    lazy var mainContext: NSManagedObjectContext = persistentContainer.viewContext
    lazy var backgroundContext: NSManagedObjectContext = persistentContainer.newBackgroundContext()
    var emptyTemperature: Int16 = CoreDataManageableConstant.emptyTemperature

    private init() { }
}

extension MockCoreDataManager {
    func deleteAllMock<T: NSManagedObject>(_ type: T.Type, _ completion: CheckSaveCompletion) {
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        request.fetchBatchSize = 100
        mainContext.performAndWait {
            let models: [T]? = try? request.execute()
            var isError: Bool = false
            if let models: [T] = models {
                models.forEach { model in
                    self.mainContext.performAndWait {
                        self.mainContext.delete(model)
                        do {
                            try self.mainContext.save()
                        } catch {
                            isError = true
                        }
                    }
                }
                if !isError {
                    completion?(.success(true))
                } else {
                    completion?(.failure(.invalid))
                }
            } else {
                completion?(.failure(.invalid))
            }
        }
    }
}
