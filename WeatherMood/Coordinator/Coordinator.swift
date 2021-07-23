//
//  Coordinator.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
