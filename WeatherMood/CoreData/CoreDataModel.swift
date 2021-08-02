//
//  CoreDataModel.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/08/02.
//

import Foundation

/// Diary의 각 타입에 대해 enum으로 할당하기 위한 연산프로퍼티 추가한다.
extension Diary {
    public var windSpeed: WindSpeed {
        get {
            WindSpeed(rawValue: Int(self.windSpeedRawValue)) ?? .soso
        }
        set {
            self.windSpeedRawValue = Int16(newValue.rawValue)
        }
    }
    
    public var discomfortIndex: DiscomfortIndex {
        get {
            DiscomfortIndex(rawValue: Int(self.discomfortRawValue)) ?? .normal
        }
        set {
            self.discomfortRawValue = Int16(newValue.rawValue)
        }
    }
    
    public var humidity: Humidity {
        get {
            Humidity(rawValue: Int(self.humidityRawValue)) ?? .proper
        }
        set {
            self.humidityRawValue = Int16(newValue.rawValue)
        }
    }
    
    public var emoticon: Emoticon {
        get {
            Emoticon(rawValue: Int(self.emoticonRawValue)) ?? .hot
        }
        set {
            self.emoticonRawValue = Int16(newValue.rawValue)
        }
    }
}
