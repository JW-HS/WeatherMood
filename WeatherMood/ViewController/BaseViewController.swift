//
//  BaseViewController.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/22.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    // MARK: - Coordinator
    weak var coordinator: MainCoordinator?

    // MARK: - Rx
    var disposeBag: DisposeBag = DisposeBag()

    // MARK: - Layout Constraints
    private(set) var didSetupConstraints: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    /// Override point
    func setupConstraints() {
    }
}
