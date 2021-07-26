//
//  Styles.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/26.
//  Reference: https://github.com/kickstarter/ios-oss/blob/main/Library/Styles/BaseStyles.swift

import UIKit

enum Styles {
    static let cornerRadius: CGFloat = 15.0

    static func grid(_ count: Int) -> CGFloat {
        4.0 * CGFloat(count)
    }
}
