//
//  CoreDataManager+Delete.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/07/27.
//
import CoreData
import Foundation
// MARK: - Delete
extension CoreDataManageble {
    /// 특정 Model을 삭제한다.
    /// - Parameters:
    ///   - diary: 선택한 Diary를 참조하여 전달한다.
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요하다.
    /// ```
    /// manager.delete(diary) { result in
    ///     switch result {
    ///     case .success(_):
    ///         print("success")
    ///     case .failure(_):
    ///         print("failed")
    ///     }
    /// }
    /// ```
    func delete(_ diary: Diary, _ completion: CheckSaveCompletion) {
        mainContext.perform {
            self.mainContext.delete(diary)
            self.save(completion)
        }
    }
    
    /// backgroundQueue로 현재 저장되어있는 모든 model를 삭제한다. ⚠️테스트용도로만 사용한다.
    /// - Parameters:
    ///   - type: 타입의 타입을 전달한다.
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요하다
    /// ```
    /// manager.deleteAll(Diary.self) { result in
    ///     switch result {
    ///     case .success(_):
    ///         print("success")
    ///     case .failure(_):
    ///         print("failed")
    ///     }
    /// }
    /// ```
    func deleteAll<T: NSManagedObject>(_ type: T.Type, _ completion: CheckSaveCompletion) {
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        request.fetchBatchSize = 100
        backgroundContext.perform {
            let models: [T]? = try? request.execute()
            var isError: Bool = false
            if let models: [T] = models {
                models.forEach { model in
                    self.backgroundContext.performAndWait {
                        self.backgroundContext.delete(model)
                        do {
                            try self.backgroundContext.save()
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
