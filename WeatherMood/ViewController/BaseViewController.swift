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

    // MARK: - Properties
    var viewModel: ViewModelType?

    // MARK: - Rx
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
}
