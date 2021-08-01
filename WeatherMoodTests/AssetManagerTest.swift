//
//  CoreDataTestDefaultModel.swift
//  WeatherMoodTests
//
//  Created by hyunsu on 2021/07/31.
//

import XCTest
@testable import WeatherMood

class AssetManagerTest: XCTestCase {
    var manager = MockCoreDataManager.shared
    
    override func tearDown() {
        manager.deleteAllMock(Diary.self, nil)
        manager.deleteAllMock(DiaryPerMonth.self, nil)
    }
    
    func test_Diary에_windy이모티콘을_추가하여_생성하고_AssetManager에서_파일이름을_가져올수있다() {
        timeout(2) { exp in
            let diary = Diary(context: manager.mainContext)
            diary.date = Date()
            diary.emoticonType = "windy"
            manager.create(diary) { result in
                switch result {
                case .success(_):
                    self.manager.fetch(limit: 1) { (diaries: [Diary]?) in
                        exp.fulfill()
                        if let diary = diaries?.first {
                            let emoticonFile = AssetManager.shared.emoticonFile[diary.emoticonType ?? ""]
                            XCTAssert(emoticonFile?.smallName == "windy")
                        } else {
                            
                            XCTFail()
                        }
                    }
                case .failure(_):
                    exp.fulfill()
                    XCTFail()
                }
            }
        }
    }
    
    func test_Diary에_verygood불쾌지수를_추가하여_생성하고_AssetManager에서_파일이름을_가져올수있다() {
        timeout(2) { exp in
            let diary = Diary(context: manager.mainContext)
            diary.date = Date()
            diary.discomfortType = "very good"
            manager.create(diary) { result in
                switch result {
                case .success(_):
                    self.manager.fetch(limit: 1) { (diaries: [Diary]?) in
                        exp.fulfill()
                        if let diary = diaries?.first {
                            let emoticonFile = AssetManager.shared.discomfortFile[diary.discomfortType ?? ""]
                            XCTAssert(emoticonFile?.smallName == "very good")
                        } else {
                            
                            XCTFail()
                        }
                    }
                case .failure(_):
                    exp.fulfill()
                    XCTFail()
                }
            }
        }
    }
}
