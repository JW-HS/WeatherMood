//
//  UIView+.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/27.
//

import UIKit

extension UIView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }

    /// 하위 뷰 목록 끝에 뷰(들)을 추가합니다.
    /// - Parameter views: 추가할 뷰(들)입니다. 추가된 후 이 뷰(들)은 다른 모든 하위 뷰 위에 나타납니다.
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
