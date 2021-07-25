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
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

extension UIViewController {
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
