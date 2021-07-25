//
//  CoreDataTest.swift
//  WeatherMoodTests
//
//  Created by hyunsu on 2021/07/22.
//

import Foundation
import XCTest
import CoreData

@testable import WeatherMood

class CoreDataTest: XCTestCase {
    
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherMood")
        let description = container.persistentStoreDescriptions.first!
        description.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let _ = error as NSError? {
                XCTFail("there is no container")
            }
        })
        return container
    }()
    
    func test_diary를_다른모델없이_하나_생성할수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { excp in
            
            manager.createDiary(title: "오늘은...", date: Date(), main: "asdfasdf") { result in
                excp.fulfill()
                switch result {
                case .success(_):
                    XCTAssertTrue(true)
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_diary만들고_가장최근_diary를_가져올수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { excp in
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (diaries: [Diary]?) in
                excp.fulfill()
                if let _ = diaries {
                    XCTAssertTrue(true)
                } else {
                    XCTFail()
                }
            }
        }
    }
    
    func test_diary만들고_삭제할수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        
        var diary: Diary!
        timeout(2) { exp in
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (diaries: [Diary]?) in
                diary = diaries!.first!
            }
            
            manager.delete(diary, nil)
            manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (diaries: [Diary]?) in
                exp.fulfill()
                XCTAssertTrue(diaries?.count == 0 )
            }
        }
    }
    
    func test_diary들을_만들고_모두_삭제할수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
 
        timeout(2) { exp in
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            
            manager.deleteAll(CoreDataStringName.diary , nil)
            manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (diaries: [Diary]?) in
                exp.fulfill()
                XCTAssertTrue(diaries!.isEmpty )
            }
        }
    }
    
    func test_diary3개만들고_가장최근_diary3개를_가져올수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { excp in
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.createDiary(title: "오늘은..", date: Date(), main: "asdfasdf", completion: nil)
            manager.fetch(by: CoreDataStringName.diary, { (diaries: [Diary]?) in
                excp.fulfill()
                XCTAssertTrue(diaries?.count == 3)
            })
        }
    }
    
    func test_default_Emoticon을_만들어_가져올수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { exp in
            manager.createDefaultEmoticon { _ in }
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                exp.fulfill()
                XCTAssertTrue(emoticons?.count == 10)
            }
        }
    }
    
    /// relationShip - rules - cascade는 연쇄적으로삭제하지만, nullify는 삭제하지않는다.
    func test_emoticon를_포함하는_diary를_만들고_diary를삭제해도_emoticon은_삭제되지않는다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        
        var emoticon: Emoticon!
        var diary: Diary!
        timeout(3) { excp in
            manager.createDefaultEmoticon(nil)
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                emoticon = emoticons!.last!
            }
            manager.createDiary(title: "asdf", date: nil, main: nil, emoticons: [emoticon]) { _ in
            }
            manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (recentDiary: [Diary]?) in
                diary = recentDiary!.first!
            }
            manager.delete(diary, nil)
            
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                excp.fulfill()
                XCTAssert(emoticons?.count == 10)
            }
        }
    }
    
    func test_emoticon를_포함하는_diary를_만들고_해당diary의_emoticon을_nil해도_emoticon은_삭제되지않는다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        
        var emoticon: Emoticon!
        var diary: Diary!
        timeout(3) { excp in
            manager.createDefaultEmoticon(nil)
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                emoticon = emoticons!.last!
            }
            manager.createDiary(title: "asdf", date: nil, main: nil, emoticons: [emoticon]) { _ in
            }
            manager.fetch(by: CoreDataStringName.diary, fetchLimit: 1) { (recentDiary: [Diary]?) in
                diary = recentDiary!.first!
            }
            diary.emoticon = nil
            manager.save(nil)
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                excp.fulfill()
                XCTAssert(emoticons?.count == 10)
            }
        }
    }
    
    func test_A뷰컨에서보고있는_diary객체를_B뷰컨에서_수정하여_같은context에서_save하면_반영된다() {
        let aViewController = MockViewController()
        let bViewController = MockViewController()
        
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { excp in
            manager.createDiary(title: "오늘은...", date: Date(), main: "asdfasdf") { _ in }
            manager.fetch(by: CoreDataStringName.diary) { (diaries: [Diary]?) in
                aViewController.diary = diaries!.first!
            }
            bViewController.diary = aViewController.diary
            bViewController.diary?.title = "ttiittllee"
            manager.save(nil)
            manager.fetch(by: CoreDataStringName.diary) { (diaries: [Diary]?) in
                excp.fulfill()
                XCTAssertTrue(diaries?.first?.title == aViewController.diary.title)
            }
        }
    }
    
    func test_A뷰컨에서보고있는_diary객체를_B뷰컨에서_수정하여_다른context에서_save하면_maincontext에서도_반영된다() {
        
        let aViewController = MockViewController()
        let bViewController = MockViewController()
        
        let context = container.viewContext
        let backgroundConetxt = container.newBackgroundContext()
        let manager = CoreDataManager()
        manager.context = context
        
        let backgroundManager = CoreDataManager()
        backgroundManager.context = backgroundConetxt
        
        timeout(2) { excp in
            manager.createDiary(title: "오늘은...", date: Date(), main: "asdfasdf") { _ in }
            manager.fetch(by: CoreDataStringName.diary) { (diaries: [Diary]?) in
                aViewController.diary = diaries!.first!
            }
            bViewController.diary = aViewController.diary
            bViewController.diary?.title = "ttiittllee"
            backgroundManager.save(nil)
            manager.fetch(by: CoreDataStringName.diary) { (diaries: [Diary]?) in
                excp.fulfill()
                XCTAssertTrue(diaries?.first?.title == aViewController.diary.title)
            }
        }
    }
    
    func test_defaultTemperature을_만들고_1도에해당하는_termpature를_뽑을수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { exp in
            manager.createDefaultTemperature(nil)
            manager.fetchOneTemperature(by: 1) { temper in
                exp.fulfill()
                XCTAssertTrue(temper?.degree == 1)
            }
        }
    }
    
    func test_defaultDiscomforIndex를_만들고_1도에해당하는_discomfortIndex를_뽑을수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        timeout(2) { exp in
            manager.createDefaultDiscomfortIndex(nil)
            manager.fetchOneDiscomfortIndex(by: 1) { discomfort in
                exp.fulfill()
                XCTAssertTrue(discomfort?.degree == 1)
            }
        }
    }
    
    /// Calendar.startDaOfDay( Date() ) 하게되면 오늘날짜 새벽0시로된다.
    /// 현재날짜로부터 7일간의데이터를 두번만든다. 그럼 총 14개가생긴다.
    /// 그래서 현재날짜로부터 7일전까지의 데이터를 fetch할경우 14개여야한다.
    func test_diary들중에서_특정날짜로부터_1주일전까지의_diary들을_뽑을수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        
        timeout(2) { exp in
            let currentDate = Date()
            for hourOffset in -6...0 {
                let entryDate = Calendar.current.date(byAdding: .day, value: hourOffset, to: currentDate)!
                manager.createDiary(title: "dasdf", date: entryDate, main: nil, completion: nil)
            }
            let nextDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
            for hourOffset in -6...0 {
                let entryDate = Calendar.current.date(byAdding: .day, value: hourOffset, to: nextDate)!
                manager.createDiary(title: "dasdf", date: entryDate, main: nil, completion: nil)
            }
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            manager.fetchPreviousWeekOfMonthDiaries(from: currentDate) { diaries in
                exp.fulfill()
                XCTAssertTrue(diaries?.count == 14, String(diaries!.count))
            }
        }
    }
    
    func test_diary들중에서_특정날짜에_해당하는_한달_diary들을_뽑을수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        
        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let components: DateComponents = calendar.dateComponents([.year, .month], from: Date())
        let startDate = calendar.date(from: components)!
        
        timeout(2) { exp in
            for hourOffset in 0..<20 {
                let entryDate = Calendar.current.date(byAdding: .day, value: hourOffset, to: startDate)!
                manager.createDiary(title: "dasdf", date: entryDate, main: nil, completion: nil)
            }
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            
            manager.fetchMonthDiaries(WhenMonthDateIs: startDate) { diaries in
                exp.fulfill()
                XCTAssertTrue(diaries?.count == 20, String(diaries!.count))
            }
        }
    }
    
    /// `relationShip`과 `derived`속성 및 `fetchEachEmoticonUsedInTotalDiaries()` 테스트
    func test_defaultEmoticon을_만들어놓고_diary들을_생성하는데_랜덤으로_emoticon을_선택하여_같이만들고_특정emoticon을_조회하여_diary들의개수를_알수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        var emotionList: [Emoticon]!
        var target: Int = 0
        var answer: Int = 1
        timeout(2) { exp in
            manager.createDefaultEmoticon(nil)
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                emotionList = emoticons
            }
            for i in 0..<1000 {
                let emoticon = emotionList.randomElement()!
                manager.createDiary(title: String(i), date: Date(), main: "asdfnajc", emoticons: [emoticon]) { result in
                    switch result {
                    case .failure(_):
                        XCTFail()
                    case .success(_): print()
                    }
                }
                if emoticon.smallEmoticonName == String(1) {
                    target += 1
                }
            }
            
            manager.fetchEachEmoticonUsedInTotalDiaries { eachEmoticons in
                eachEmoticons?.forEach {
                    if $0.smallEmoticonName == "1" {
                        answer = $0.count
                    }
                }
                exp.fulfill()
                XCTAssertEqual(target, answer)
            }
        }
    }
    
    /// `fetchEachEmoticonUsedInDiariesDuringMonth()` 테스트
    func test_defaultEmoticon을_만들어놓고_한달동안의_diary들을_생성하는데_랜덤으로_emoticon을_선택하여_같이만들고_각Diary들에_사용된_이모티콘개수를_알수있다() {
        let context = container.viewContext
        let manager = CoreDataManager()
        manager.context = context
        var emotionList: [Emoticon]!

        var calendar: Calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let components: DateComponents = calendar.dateComponents([.year, .month], from: Date())
        let startDate = calendar.date(from: components)!
        
        var dict: [String: Int] = [:]
        
        timeout(2) { exp in
            manager.createDefaultEmoticon(nil)
            manager.fetch(by: CoreDataStringName.emoticon) { (emoticons: [Emoticon]?) in
                emotionList = emoticons
            }
            
            for hourOffset in 0..<20 {
                let emoticon = emotionList.randomElement()!
                let entryDate = Calendar.current.date(byAdding: .day, value: hourOffset, to: startDate)!
                manager.createDiary(title: "dasdf", date: entryDate, main: nil, emoticons: [emoticon], completion: nil)
                dict[emoticon.smallEmoticonName!, default: 0] += 1
            }
            
            let answer: [(String, Int)] = dict.sorted(by: { $0.value == $1.value ? $0.key < $1.key : $0.value > $1.value })
            manager.fetchEachEmoticonUsedInDiariesDuringMonth(WhenMonthDateIs: startDate) { eachEmoticons in
                exp.fulfill()
                if let eachEmoticons = eachEmoticons {
                    var isSuccess = true
                    zip(eachEmoticons, answer).forEach {
                        if $0.0 != $1.0 || $0.1 != $1.1 {
                            isSuccess = false
                        }
                    }
                    XCTAssert(isSuccess)
                } else {
                    XCTFail()
                }
            }
        }
    }
}


extension XCTestCase {
    func timeout(_ timeout: TimeInterval, completion: (XCTestExpectation) -> Void) {
        let exp = expectation(description: "Timeout: \(timeout) seconds")
        
        completion(exp)
        
        waitForExpectations(timeout: timeout) { error in
            guard let error = error else { return }
            XCTFail("Timeout error: \(error)")
        }
    }
}





