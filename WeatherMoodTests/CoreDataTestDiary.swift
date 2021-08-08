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

class CoreDataTestDiary: XCTestCase {
    var manager = MockCoreDataManager.shared
    
    override func tearDown() {
        manager.deleteAllMock(Diary.self, nil)
        manager.deleteAllMock(DiaryPerMonth.self, nil)
    }
    
    //MARK: - Test
    func test_diary를_다른모델없이_하나_생성할수있다() {
        timeout(2) { excp in
            let model = Diary(context: manager.mainContext)
            model.title = "asfda.."
            model.date = Date()
            manager.create(model) { result in
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
    
    func test_diary를_만들면_perMonth가져올수있다() {
        timeout(2) { exp in
            createMockDiary {
                self.manager.fetch { (diaryPerMonths: [DiaryPerMonth]?) in
                    exp.fulfill()
                    XCTAssert(diaryPerMonths!.count == 1)
                }
            }
        }
    }
    
    func test_같은내용의Diary를_두개생성해도_2개다() {
        let date = Date()
        timeout(2) { exp in
            let model = Diary(context: manager.mainContext)
            model.title = "asfda.."
            model.date = date
            manager.create(model) { result in
                switch result {
                case .success(_):
                    let model = Diary(context: self.manager.mainContext)
                    model.title = "asfda.."
                    model.date = date
                    self.manager.create(model) { result in
                        self.manager.fetch { (diaries: [Diary]?) in
                            exp.fulfill()
                            if let diary = diaries {
                                XCTAssertTrue(diary.count == 2, String(diary.count))
                            } else {
                                XCTFail()
                            }
                        }
                    }
                case .failure(_):
                    XCTFail()
                }
            }
        }
    }
    
    func test_diary를_fetch하면_처음에는_0개가되어야한다() {
        timeout(3) { exp in
            self.manager.fetch { (diaries: [Diary]?) in
                exp.fulfill()
                if let diary = diaries {
                    XCTAssertTrue(diary.count == 0, String(diary.count))
                } else {
                    XCTFail()
                }
            }
        }
    }

    func test_diary만들고_가장최근_diary를_가져올수있다() {
        timeout(3) { excp in
            let model = Diary(context: manager.mainContext)
            model.title = "asfda.."
            model.date = Date()
            manager.create(model) { result in
                switch result {
                case .success(_) :
                    self.manager.fetch { (diaries: [Diary]?) in
                        excp.fulfill()
                        if let diary = diaries {
                            XCTAssertTrue(diary.count == 1, String(diary.count))
                        } else {
                            XCTFail()
                        }
                    }
                case .failure(_) :
                    excp.fulfill()
                    XCTFail()
                }
            }
        }
    }
    
    func test_diary만들고_삭제할수있다() {
        timeout(2) { exp in
            self.createMockDiary {
                self.manager.fetch(limit: 1) { (fetched: [Diary]?) in
                    let diary = fetched!.first!
                    self.manager.delete(diary) { result in
                        switch result {
                        case .success(_):
                            self.manager.fetch(limit: 1) { (diaries: [Diary]?) in
                                exp.fulfill()
                                XCTAssertTrue(diaries?.count == 0, String(diaries!.count))
                            }
                        case .failure(_):
                            exp.fulfill()
                            XCTFail()
                        }
                        
                    }
                }
            }
        }
    }
    
    func test_diary들을_만들고_모두_삭제할수있다() {
        timeout(2) { exp in
            self.createMockDiary {
                self.createMockDiary {
                    self.createMockDiary {
                        self.manager.deleteAll(Diary.self) { result in
                            print("삭제삭제")
                            switch result {
                            case .success(_) :
                                self.manager.fetch(limit: 2) { (diaries: [Diary]?) in
                                    exp.fulfill()
                                    XCTAssertTrue(diaries!.isEmpty, String(diaries!.count))
                                }
                            case .failure(_):
                                exp.fulfill()
                                XCTFail()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func test_diary를_만들고_삭제하면_DiaryPerMonth에도_없다() {
        timeout(2) { exp in
            let date = Date()
            self.createMockDiary(date) {
                self.manager.fetch(limit: 1) { (fetched: [Diary]?) in
                    let diary = fetched!.first!
                    self.manager.delete(diary) { result in
                        switch result {
                        case .success(_):
                            self.manager.fetch(limit: 1) { (diaries: [DiaryPerMonth]?) in
                                exp.fulfill()
                                let index = date.indexByMonth()!
                                XCTAssert(diaries!.first!.emoticonArray!.filter{$0 != 0}.count == 0 )
                            }
                        case .failure(_):
                            exp.fulfill()
                            XCTFail()
                        }
                        
                    }
                }
            }
        }
    }

    func test_Diary를_하나만들고_업데이트할수있다() {
        timeout(2) { exp in
            createMockDiary {
                self.manager.fetch { (diaries: [Diary]?) in
                    if let diary = diaries?.first {
                        diary.title = "update"
                        self.manager.update(diary) { result in
                            self.manager.fetch { (diaries: [Diary]?) in
                                exp.fulfill()
                                XCTAssert(diaries!.first!.title == "update")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func test_diary를_2개_만들면_perMontn의_emoticonArray에는_두개를_가져올수있다() {
        timeout(2) { exp in
            createMockDiary(Date().day(by: +3)!,
                            emoticon: .sunny) {
                self.createMockDiary(Date().day(by: +1)!,
                                     emoticon: .hot ) {
                    self.manager.fetch { (diaryPerMonths: [DiaryPerMonth]?) in
                        exp.fulfill()
                        XCTAssert(diaryPerMonths!.first!.emoticonArray!.filter{$0 != 0}.count == 2, String(diaryPerMonths!.first!.emoticonArray!.filter{$0 != 0 }.count))
                    }
                }
            }
        }
    }
    
    func test_diary를_2개_만들어_수정하여_perMonth에서도_반영된다() {
        timeout(2) { exp in
            createMockDiary(emoticon: .hot) {
                self.manager.fetch({ (diaries: [Diary]?) in
                    let diary = diaries!.first!
                    diary.emoticon = .rainy
                    self.manager.update(diary) { _ in
                        self.manager.fetch { (diaryPerMonths: [DiaryPerMonth]?) in
                            exp.fulfill()
                            let index = Date().indexByMonth()!
                            print(diaryPerMonths!.first!.emoticonArray)
                            XCTAssert(diaryPerMonths!.first!.emoticonArray![index] == Emoticon.rainy.rawValue, String(diaryPerMonths!.first!.emoticonArray![index]))
                        }
                    }
                })
            }
        }
    }
    
    func test_오늘날짜_diary를_만들고_어제날짜Diary를_만들면_가장먼저나오는_Diary는_오늘날짜Diary다() {
        timeout(2) { exp in
            let curDate = Date()
            let beforeDate = Date().day(by: -2)!
            createMockDiary(beforeDate.day(by: -3)!) {
                self.createMockDiary(curDate) {
                    self.createMockDiary(beforeDate) {
                        self.manager.fetch { (diary: [Diary]?) in
                            exp.fulfill()
                            diary!.forEach{print($0.date)}
                            XCTAssert(diary!.first!.date == curDate)
                        }
                    }
                }
            }
        }
    }
}

extension CoreDataTestDiary {
    func createMockDiary(_ date: Date = Date(),
                         emoticon: Emoticon = .hot,
                         _ completion: @escaping (() -> Void)) {
        let model = Diary(context: manager.mainContext)
        model.title = "오늘은.."
        model.date = date
        model.emoticon = .hot
        manager.create(model) { _ in
            completion()
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





