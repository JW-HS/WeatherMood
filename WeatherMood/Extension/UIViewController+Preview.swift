//
//  UIViewController+Preview.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/25.
//  source: https://fluffy.es/xcode-previews-uikit/

import UIKit

#if DEBUG
import SwiftUI

private struct Preview: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    let viewController: UIViewControllerType

    func makeUIViewController(context: Context) -> UIViewControllerType {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

extension UIViewController {
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
