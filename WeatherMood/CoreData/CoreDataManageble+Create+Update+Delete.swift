//
//  CoreDataManageable
//  WeatherMood
//
//  Created by hyunsu on 2021/07/27.
//
import CoreData
import Foundation

// MARK: - Create
extension CoreDataManageable {
    /// Diary객체를 만들고 저장한다.
    /// - Parameters:
    ///   - model: Diary 객체를 만들고 전달한다.
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요하다.
    /// ⚠️Diary객체를 만들고서 create호출을 안하도록 하면 안된다. 계속 context에 남아있기 때문에, 반드시 create를 호출할때 Diary객체를 만들도록 해야한다.
    ///
    ///  이모티콘, 불쾌지수는 AssertEmoticonManager의  smallName( String ) 으로 저장한다.
    ///
    ///  기온은 "-100" ~ "100" 사이의  ( String )으로 저장한다.
    ///
    ///  습도는 "1"~"5" 사이의  ( String )으로 저장한다.
    ///
    ///  풍량은 "1"~"5" 사이의  ( String )으로 저장한다.
    /// ```
    /// let diary = Diary(context: CoreDataManager.shared.context)
    /// ...
    /// CoreDataManager.shared.create(diary) { result in
    ///     case result {
    ///     .success(_):
    ///         print("created")
    ///     .failure(_):
    ///         print("fail!")
    ///     }
    /// }
    /// ```
    func create(_ model: Diary,
                _ completion: CheckSaveCompletion) {
        mainContext.perform {
            createBy(model.date) { diaryPerMonth in
                guard let diaryPerMonth = diaryPerMonth else {
                    completion?(.failure(.invalid))
                    return
                }
                bind(model, to: diaryPerMonth)
                self.save(completion)
            }
        }
    }
    
    /// Diary과 Diary의 날짜에 해당하는 DiaryPerMonth에 사용된 온도, 풍량, 습도, 불쾌지수, 이모티콘을 할당하는 메서드입니다. DiaryPerMonth는 월간별로 사용된 온도, 풍량, 습도, 불쾌지수, 이모티콘을 빠르게 확인할 수 있도록 하는 객체입니다.
    /// - Parameters:
    ///   - model: 특정 Diary를 이용합니다.
    ///   - perModel: 해당 Diary의 날짜에 해당하는 DiaryPerMonth를 이용합니다. 
    private func bind(_ model: Diary,
                      to perModel: DiaryPerMonth,
                      isDelete: Bool = false ) {
        guard let date = model.date,
              let index = date.indexByMonth() else {
            return
        }
        perModel.discomfortArray?[index] = isDelete ? 0 : model.discomfortRawValue
        perModel.temperatureArray?[index] = isDelete ? emptyTemperature : model.temperature
        perModel.emoticonArray?[index] = isDelete ? 0 : model.emoticonRawValue
        perModel.humidityArray?[index] = isDelete ? 0 : model.humidityRawValue
        perModel.windSpeedArray?[index] = isDelete ? 0 : model.windSpeedRawValue
    }
    
    /// 해당 날짜에 해당하는 월 DiaryPerMonth를 가져오는데, 없는 경우에는 빈값을 만들어 가져온다
    private func createBy(_ target: Date?,
                          _ completion: @escaping (DiaryPerMonth?) -> Void) {
        guard let date = target?.filteredMonth(),
              let numDays = date.numberOfDaysByMonth() else {
            completion(nil)
            return }
        let request: NSFetchRequest<DiaryPerMonth> = DiaryPerMonth.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "date == %@", date as NSDate)
        request.predicate = predicate
        mainContext.perform {
            guard let model: DiaryPerMonth = try? request.execute().first else {
                let perMonth: DiaryPerMonth = DiaryPerMonth(context: self.mainContext)
                perMonth.date = date
                perMonth.emoticonArray = Array(repeating: 0, count: numDays)
                perMonth.humidityArray = Array(repeating: 0, count: numDays)
                perMonth.temperatureArray = Array(repeating: emptyTemperature, count: numDays)
                perMonth.windSpeedArray = Array(repeating: 0, count: numDays)
                perMonth.discomfortArray = Array(repeating: 0, count: numDays)
                self.save { result in
                    switch result {
                    case .success(_):
                        completion(perMonth)
                    case .failure(_):
                        completion(nil)
                    }
                }
                return
            }
            completion(model)
        }
    }
}

// MARK: - Update
extension CoreDataManageable {
    /// 수정한 `Diary`를 업데이트한다.
    /// - Parameters:
    ///   - diary: 수정한 Diary를 `참조`하여 전달한다.
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요하다.
    /// ```
    /// manager.update(diary) { result in
    ///     switch result {
    ///     case .success(_):
    ///         print("success")
    ///     case .failure(_):
    ///         print("failed")
    ///     }
    /// }
    /// ```
    func update(_ diary: Diary, _ completion: CheckSaveCompletion) {
        mainContext.perform {
            createBy(diary.date) { diaryPerMonth in
                guard let diaryPerMonth = diaryPerMonth else {
                    completion?(.failure(.invalid))
                    return
                }
                bind(diary, to: diaryPerMonth)
                self.save(completion)
            }
        }
    }
}

extension CoreDataManageable {
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
            createBy(diary.date) { diaryPerMonth in
                guard let diaryPerMonth = diaryPerMonth else {
                    completion?(.failure(.invalid))
                    return
                }
                bind(diary, to: diaryPerMonth, isDelete: true)
                self.mainContext.delete(diary)
                self.save(completion)
            }
        }
    }
}
