//
//  AssetEmoticonManager.swift
//  WeatherMood
//
//  Created by hyunsu on 2021/08/01.
//

import Foundation


/// Asset에 있는 이미지및 json파일 이름을 매핑시켜주는 매니저이다.
/// ```
/// // CoreData에서 Diary를 가져오고, 이미지파일 가져오는 방법.
/// CoreDataManager.shared.fetch(limit: 1) { (diaries: [Diary]?) in
///     if let diary = diaries?.first {
///         if let emoticonFile = AssetManager.shared.emoticonFile[diary.emoticonType ?? ""] {
///            let image = UIImage(named: emoticonFile.smallName)
///         }
///     }
/// }
/// ```
class AssetManager {
    static var shared: AssetManager = AssetManager()
    
    let emoticonFile: [String: (smallName: String,
                                bigName: String,
                                index: Int )] = [
        "windy": (smallName: "windy", bigName: "windyBig", index: 0),
        "sunny": (smallName: "sunny", bigName: "sunnyBig", index: 1),
        "rainy": (smallName: "rainy", bigName: "rainyBig", index: 2)]
    
    let discomfortFile: [String: (smallName: String,
                                  smallSelectedName: String,
                                  index: Int )] = [
        "very good": (smallName: "very good", smallSelectedName: "very good selected", index: 0),
        "good": (smallName: "good", smallSelectedName: "good selected", index: 1),
        "soso": (smallName: "soso", smallSelectedName: "soso selected", index: 2),
        "not bad": (smallName: "bad", smallSelectedName: "bad selected", index: 3),
        "bad": (smallName: "bad", smallSelectedName: "bad selected", index: 4),
        "very bad": (smallName: "very bad", smallSelectedName: "very bad selected", index: 5)]

    enum HumidityFile {
        static let smallName: String = "humidity"
        static let smallSelectedName: String = "humidity selected"
    }

    enum WindSpeedFile {
        static let smallName: String = "windSpeed"
        static let smallSelectedName: String = "windSpeed selected"
    }

    private init() { }
}
