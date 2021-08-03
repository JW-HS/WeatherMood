//
//  CoreDataType.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/08/02.
//

import Foundation

/// CoreData Model의 타입을 Asset파일로 매핑하도록 선언하는  protocol이다.
protocol ModelTypeFileable {
    /// CoreData Model의 타입을 Asset파일로 매핑하는 메서드이다.
    func file()
}

/// CoreData의 `Emoticon` 프로퍼티에 저장하는 타입이다.
///
/// file() 메소드를 통하여 asset에 있는 파일을 가져올 수 있다.
///
/// empty case는 없는경우를 의미하며, DiaryPerMonth 해당날짜에 일기가 없다는 의미다. 일기를 삭제하는 경우에만 자동적으로 empty를 부여한다.
public enum Emoticon: Int, CaseIterable {
    case empty
    case sunny
    case rainy
    case hot
    
    func file() {
    }
}

/// CoreData의 `DiscomfortIndex`프로퍼티에 저장하는 타입이다.
///
/// file() 메소드를 통하여 asset에 있는 파일을 가져올 수 있다.
///
/// empty case는 없는경우를 의미하며, DiaryPerMonth 해당날짜에 일기가 없다는 의미다. 일기를 삭제하는 경우에만 자동적으로 empty를 부여한다.
public enum DiscomfortIndex: Int, CaseIterable, ModelTypeFileable {
    case empty
    case veryBad
    case bad
    case normal
    case good
    case veryGood
    
    func file() {
    }
}

/// CoreData의 `Humidity`프로퍼티에 저장하는 타입이다.
///
/// file() 메소드를 통하여 asset에 있는 파일을 가져올 수 있다.
///
/// empty case는 없는경우를 의미하며, DiaryPerMonth 해당날짜에 일기가 없다는 의미다. 일기를 삭제하는 경우에만 자동적으로 empty를 부여한다.
public enum Humidity: Int, CaseIterable, ModelTypeFileable {
    case empty
    case rare
    case littleBit
    case soso
    case proper
    case much
    
    func file() {
    }
}

/// CoreData의 `WindSpeed`프로퍼티에 저장하는 타입이다.
///
/// file() 메소드를 통하여 asset에 있는 파일을 가져올 수 있다.
///
/// empty case는 없는경우를 의미하며, DiaryPerMonth 해당날짜에 일기가 없다는 의미다. 일기를 삭제하는 경우에만 자동적으로 empty를 부여한다.
public enum WindSpeed: Int, CaseIterable, ModelTypeFileable {
    case empty
    case veryWeak
    case weak
    case soso
    case strong
    case veryStrong
    
    func file() {
    }
}
