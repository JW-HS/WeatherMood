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

/// CoreData model들을 CRUD기능으로 구현한 manager.
///
/// ⚠️다른뷰컨트롤러에서 사용할때는 매번 manager객체를 새로만들지않고, 참조하도록 하자.
///
/// ⚠️기본적으로 모든 기능들은 비동기클로저를 받는다. 항상 에러핸들링 또는 옵셔널바인딩이 필요하다. 주로 Create, Update, Delete는 에러핸들링이 필요하고, Read는 옵셔널바인딩이 필요하다.
///
/// ⚠️습도, 온도, 불쾌지수, 이모티콘은 앱초기에 단한번만 실행하여 절대 삭제하지않도록한다.
/// ```
/// let manager = CoreDatManager()
/// manager.createDiary(title: "오늘은...", date: Date(), main: "asdfasdf") { result in
///     switch result {
///     case .success(_):
///     case .failure(_):
///     }
/// }
/// ```
class CoreDataManager {
    var context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }()
    
    typealias CheckSaveCompletion = ((Result<Bool, CoreDataError>) -> Void)?
    typealias EachEmoticonCount = (smallEmoticonName: String, count: Int)
    
    func save(_ completion: CheckSaveCompletion ) {
        context?.performAndWait {
            do {
                try self.context?.save()
                completion?(.success(true))
            } catch {
                print(error)
                completion?(.failure(.invalid))
            }
        }
    }
    
    // MARK: - Create
    /// Emoticon,Humidiy,Discomfort,Temperature를 모델자체로받는이유는, 그전에 viewContext로  각 모델들을 맞는걸로조회하여 가져올것이기때문?!
    
    /// Diary모델을 create하는 메서드
    /// - Parameters:
    ///   - title: Diary모델의 title
    ///   - date: Diary모델의 date
    ///   - main: Diary모델의 본문
    ///   - emoticons: Diary에 사용된 이모티콘배열 - Emoticon 모델을 직접만들지않고 참조하여 전달.
    ///   - humidity: Diary에 사용된 습도 - Humidity 모델을 직접만들지않고, 참조하여전달, fetchOneHumidity()메서드 사용하여 사용자가선택한 습도를 토대로  가져와, 전달한다.
    ///   - discomfortIndex: Diary에 사용된 불쾌지수 - DiscomfortIndex 모델을 직접만들지않고, 참조하여전달, `fetchOneDiscomfortIndex()메서드 사용하여 사용자가선택한 불쾌지수를 토대로 가져와, 전달한다.
    ///   - temperature: Diary에 사용된 온도 - Temperature 모델을 직접만들지않고, 참조하여전달, fetchOneDiscomfortIndex()메서드 사용하여 사용자가선택한 온도를 토대로 가져와, 전달한다.
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요.
    /// ```
    /// manager.createDiary(title: "제목",
    ///                     date: Date(),
    ///                     main: "본문",
    ///                     emoticons: [emoticon]) { _ in }
    /// ```
    func createDiary(title: String?,
                     date: Date?,
                     main: String?,
                     emoticons: [Emoticon] = [],
                     humidity: Humidity? = nil,
                     discomfortIndex: DiscomfortIndex? = nil,
                     temperature: Temperature? = nil,
                     completion: CheckSaveCompletion ) {
        guard let context = self.context else {
            completion?(.failure(.invalid))
            return
        }
        context.performAndWait {
            let model: Diary = Diary(context: context)
            model.title = title
            model.date = date
            model.main = main
            model.emoticon = NSSet(array: emoticons)
            model.humidity = humidity
            model.temperature = temperature
            model.discomfort = discomfortIndex
            self.save(completion)
        }
    }
    
    // TODO: ⚠️이모티콘 파일생길경우 교체해줘야함.
    /// 기본적으로 이모티콘파일들이름으로 이모티콘들을 만들어둔다. ⚠️ 앱을 처음실행할떄 반드시 한번만 실행되어야함.
    /// - Parameter completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요
    func createDefaultEmoticon(_ completion: CheckSaveCompletion) {
        guard let context = self.context else {
            completion?(.failure(.invalid))
            return
        }
        context.performAndWait {
            for randomIdx in 0..<10 {
                let emoticon: Emoticon = Emoticon(context: context)
                emoticon.smallEmoticonName = String(randomIdx)
            }
            
            self.save(completion)
        }
    }

    /// -100도부터 100도까지 `온도`를 기본적으로 만들어둔다. ⚠️ 앱을 처음실행할떄 반드시 한번만 실행되어야함.
    /// - Parameter completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요.
    func createDefaultTemperature(_ completion: CheckSaveCompletion) {
        guard let context = self.context else {
            completion?(.failure(.invalid))
            return
        }
        context.performAndWait {
            for temper in -100...100 {
                let emoticon: Temperature = Temperature(context: context)
                emoticon.degree = Int16(temper)
            }
            self.save(completion)
        }
    }
    
    /// 0~100까지 `불쾌지수`를 기본적으로 만들어둔다. ⚠️ 앱을 처음실행할떄 반드시 한번만 실행되어야함.
    func createDefaultDiscomfortIndex(_ completion: CheckSaveCompletion) {
        guard let context = self.context else {
            completion?(.failure(.invalid))
            return
        }
        context.performAndWait {
            for temper in 0...100 {
                let emoticon: DiscomfortIndex = DiscomfortIndex(context: context)
                emoticon.degree = Int16(temper)
            }
            self.save(completion)
        }
    }
    
    // TODO: ⚠️ `습도` 기본적으로만들기
    /// `습도`를 기본적으로 만들어둔다. ⚠️ 앱을 처음실행할떄 반드시 한번만 실행되어야함.
    func createDefaultHumidity() {
    }
    
    // MARK: - Fetch

    /// T타입에해당하는 모델을 fetchLimit만큼 가져온다. default로 100개이다.
    /// - Parameters:
    ///   - name: 특정 model 이름
    ///   - fetchLimit: 모델데이터 리스트 최대개수를 지정한다. default로 100개이다.
    ///   - completion: 특정 model타입의 배열을 인자로 받는 비동기 클로저며, 에러가날경우 nil을 받게되고, 없는경우는 count가 0이될것. 옵셔널바인딩이 필요함.
    /// ```
    /// manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (diaries: [Diary]?) in
    /// if let _ = diaries {
    /// }
    /// ```
    func fetch<T: NSFetchRequestResult>(by name: String,
                                        fetchLimit: Int = 100,
                                        _ completion: @escaping(([T]?) -> Void) ) {
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: name)
        request.fetchLimit = fetchLimit
        request.fetchBatchSize = 100
        context?.performAndWait {
            let temperature: [T]? = try? request.execute()
            completion(temperature)
        }
    }
    
    /// 사용자가 선택한 온도를 토대로 이미있는 Temperature model을 가져온다.
    /// - Parameters:
    ///   - degree: 사용자가 선택한 온도
    ///   - completion: Tmperature모델을 인자로받는 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요함.
    ///
    /// NSPredicate - https://onelife2live.tistory.com/35
    ///
    /// NSInteger인경우는 %d 로 사용한다.
    ///
    /// String인 경우는 %@로 사용한다.
    func fetchOneTemperature(by degree: Int,
                             _ completion: @escaping((Temperature?) -> Void)) {
        let request: NSFetchRequest<Temperature> = Temperature.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "degree == %d", degree as NSInteger)
        request.predicate = predicate
        context?.performAndWait {
            let temperature: [Temperature]? = try? request.execute()
            completion(temperature?.first)
        }
    }
    
    /// 사용자가 선택한 불쾌지수를 토대로 이미있는 DiscomfortIndex model을 가져온다.
    /// - Parameters:
    ///   - degree: 사용자가 선택한 온도
    ///   - completion: DiscomfortIndex모델을 인자로받는 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요함.
    func fetchOneDiscomfortIndex(by degree: Int,
                                 _ completion: @escaping((DiscomfortIndex?) -> Void)) {
        let request: NSFetchRequest<DiscomfortIndex> = DiscomfortIndex.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "degree == %d", degree as NSInteger)
        request.predicate = predicate
        context?.performAndWait {
            let temperature: [DiscomfortIndex]? = try? request.execute()
            completion(temperature?.first)
        }
    }
    
    // TODO: ⚠️Humidity 기획완료되느대로 수정
    /// 미구현
    func fetchOneHumidity(by type: String,
                          _ completion: @escaping((Humidity?) -> Void)) {
    }
    
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
        
        context?.performAndWait {
            let list: [Diary]? = try? request.execute()
            completion(list)
        }
    }

    /// 특정날짜에 속한 한달Diary들을 가져온다.
    /// - Parameters:
    ///   - target: 가져오고자하는 달에 해당하는 어떤날짜든 상관없는 Date
    ///   - completion: Diary모델 배열을 인자로받는 비동기 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요함.
    func fetchMonthDiaries(WhenMonthDateIs target: Date,
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
        
        context?.performAndWait {
            let list: [Diary]? = try? request.execute()
            completion(list)
        }
    }
    
    /// 특정날짜에 속한 한달Diary들중에서 각Diary들에 사용된 Emoticon횟수를  정렬하여, (smallImageName, Int ) 배열로 가져온다.
    /// - Parameters:
    ///   - target: 가져오고자하는 달에 해당하는 어떤날짜든 상관없는 Date
    ///   - completion: (String, Int)? 배열을 인자로받는 비동기 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요함.
    func fetchEachEmoticonUsedInDiariesDuringMonth(WhenMonthDateIs target: Date,
                                                   _ completion: @escaping (([EachEmoticonCount]?) -> Void )) {
        fetchMonthDiaries(WhenMonthDateIs: target) { diaries in
            guard let diaries = diaries else {
                completion(nil)
                return
            }
            let emoticons: [[Emoticon]] = diaries.compactMap { $0.emoticon?.allObjects as? [Emoticon] }
            if emoticons.isEmpty {
                completion(nil)
                return
            }
            var dict: [String: Int] = [String: Int]()
            emoticons.forEach { list in
                list.forEach {
                    if let name: String =  $0.smallEmoticonName {
                        dict[name, default: 0] += 1
                    }
                }
            }
            let eachEmoticonCount: [(String, Int)] = dict.sorted(by: { $0.value == $1.value ? $0.key < $1.key : $0.value > $1.value })
            let result: [(EachEmoticonCount)] = eachEmoticonCount
            completion(result)
        }
    }
    
    ///  모든 Diary에 사용된 각각의emoticon들을 횟수와함께 가져온다.
    /// - Parameter completion:  (String, Int)? 배열을 인자로받는 비동기 클로저로, 에러날경우 nil을 반환하고, 없는경우 count가 0이될것이고, 옵셔널바인딩이 필요함.
    func fetchEachEmoticonUsedInTotalDiaries(_ completion: @escaping (([EachEmoticonCount]?) -> Void) ) {
        fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
            guard let emoticons = emoticons else {
                completion(nil)
                return
            }
            var eachEmoticon: [EachEmoticonCount] = []
            emoticons.forEach {
                if let name: String = $0.smallEmoticonName {
                    eachEmoticon.append((name, Int($0.diaryCount)))
                }
            }
            eachEmoticon.sort(by: { $0.1 == $1.1 ? $0.0 < $1.0 : $0.1 > $1.1 })
            if eachEmoticon.isEmpty {
                completion(nil)
                return
            }
            completion(eachEmoticon)
        }
    }

    // MARK: - Update
    
    /// 수정한 `Diary`를 업데이트한다.
    /// - Parameters:
    ///   - diary: 수정한 Diary를 `참조`하여 전달
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요.
    func update(_ diary: Diary, _ completion: CheckSaveCompletion) {
        context?.performAndWait {
            self.save(completion)
        }
    }
    
    // MARK: - Delete
    
    /// 특정 Model을 삭제한다. 무조건 선택한 Diary를 삭제하는용도로만 사용해야한다.
    /// - Parameters:
    ///   - diary: 선택한 Diary를 참조하여 전달.
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요.
    /// ```
    /// manager.delete(diary, nil)
    /// ```
    /// ⚠️테스트용도로만 Emoticon, Termperature, Humidity, DiscomfortIndex를 삭제한다.
    func delete<T: NSManagedObject>(_ diary: T, _ completion: CheckSaveCompletion) {
        context?.performAndWait {
            self.context?.delete(diary)
            self.save(completion)
        }
    }
    
    /// 현재 저장되어있는 모든 model를 삭제한다. ⚠️테스트용도로만 사용한다.
    /// - Parameters:
    ///   - modelName: 특정 model을 의미하는 string
    ///   - completion: Result< Bool, Error > 를 인자로 받는 비동기 클로져로, 성공할경우 true를 받게되고, 실패할경우 Error를 받게된다. 에러핸들링 필요.
    /// ```
    /// manager.deleteAll(CoreDataStringName.diary, nil)
    /// ```
    func deleteAll(_ modelName: String, _ completion: CheckSaveCompletion) {
        fetch(by: modelName) { (diaries: [Diary]?) in
            if let diaries: [Diary] = diaries {
                diaries.forEach {
                    self.delete($0, completion)
                }
            } else {
                completion?(.failure(.invalid))
            }
        }
    }
}
