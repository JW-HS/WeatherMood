//
//  UIView+Preview.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/25.
//  source: https://dev.to/gualtierofr/preview-uikit-views-in-xcode-3543

import UIKit

#if DEBUG
import SwiftUI

private struct Preview: UIViewRepresentable {
    typealias UIViewType = UIView
    let view: UIViewType

    func makeUIView(context: Context) -> UIViewType {
        view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

extension UIView {
    func toPreview() -> some View {
        Preview(view: self)
    }
}
#endif
