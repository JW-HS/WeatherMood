//
//  CoreDataTestStatistic.swift
//  WeatherMoodTests
//
//  Created by hyunsu on 2021/07/31.
//

import XCTest
@testable import WeatherMood

class CoreDataTestStatistic: XCTestCase {
    var manager = MockCoreDataManager.shared
    
    override func tearDown() {
        manager.deleteAllMock(Diary.self, nil)
        manager.deleteAllMock(DiaryPerMonth.self, nil)
    }
    //MARK: - Test
    //TODO: ⚠️테스트예정
}

