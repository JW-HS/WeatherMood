//
//  MainViewController.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/22.
//

import UIKit

import RxCocoa
import RxSwift

final class MainViewController: BaseViewController, Viewable {
    // MARK: - View Properties
    // MARK: Current Status or Weather
    lazy var currentWeatherContainerViewHeightAnchor: NSLayoutConstraint = self.currentWeatherContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)

    private let currentWeatherContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // FIXME: Status 말고 적절한 변수명으로 변경하기
    private let currentStatusLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "오늘 현수님의 하늘은 어땠나요?"
        label.font = UIFont.systemFont(ofSize: Styles.grid(4), weight: .bold)
        label.isHidden = false
//        label.setContentHuggingPriority(.defaultLow, for: .vertical)
//        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()

    private let currentWeatherView: CurrentWeatherView = {
        let view: CurrentWeatherView = CurrentWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: Content
    private lazy var contentContainerView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [contentEditMenuContainerView, contentTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Styles.grid(4)
        return stackView
    }()

    private lazy var contentEditMenuContainerView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [contentEmptyView, contentWriteButton, contentEditButton, contentDeleteButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = Styles.grid(2)
        return stackView
    }()

    private let contentEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let contentWriteButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.isHidden = false
        return button
    }()

    private let contentEditButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.isHidden = true
        return button
    }()

    private let contentDeleteButton: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.isHidden = true
        return button
    }()

    private var _isWrite: Bool = false
    private var isWrite: Bool {
        _isWrite.toggle()
        return _isWrite
    }

    private let contentTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemYellow
        textView.layer.cornerRadius = Styles.cornerRadius
        textView.isEditable = false
        textView.textColor = .label
        textView.text = "마음의 날씨를 기록해보세요!"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(4), right: Styles.grid(4))
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return textView
    }()

    // MARK: Suggestion Text
    private let guideContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.isHidden = true
        return view
    }()

    private let suggestionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "💡 비 온 뒤 땅이 더 굳어진답니다"
        label.textAlignment = .center
        return label
    }()

    // MARK: Week View
    private let weekFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .zero
        return flowLayout
    }()

    private lazy var weekCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: weekFlowLayout)
        collectionView.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        setupViews()
        bindWeekCollectionView()
    }

    // MARK: - Setup
    func setupViews() {
        currentWeatherContainerView.addSubviews(currentStatusLabel, currentWeatherView)

        let suggestionContainerView: UIView = {
            let view: UIView = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .systemTeal
            view.layer.cornerRadius = Styles.cornerRadius
            view.layer.masksToBounds = false
            return view
        }()
        suggestionContainerView.addSubview(suggestionLabel)

        let containerStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [currentWeatherContainerView, contentContainerView, suggestionContainerView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = Styles.grid(4)
            return stackView
        }()

        view.addSubviews(containerStackView, weekCollectionView)

        currentWeatherContainerViewHeightAnchor.isActive = true

        NSLayoutConstraint.activate([
            // in currentWeatherContainerView
            currentStatusLabel.centerYAnchor.constraint(equalTo: currentWeatherContainerView.centerYAnchor),
            currentStatusLabel.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor),
            currentWeatherView.centerYAnchor.constraint(equalTo: currentWeatherContainerView.centerYAnchor),
            currentWeatherView.centerXAnchor.constraint(equalTo: currentWeatherContainerView.centerXAnchor),
            // suggestionContainerView
            suggestionLabel.leadingAnchor.constraint(equalTo: suggestionContainerView.leadingAnchor, constant: Styles.grid(2)),
            suggestionLabel.topAnchor.constraint(equalTo: suggestionContainerView.topAnchor, constant: Styles.grid(4)),
            suggestionLabel.trailingAnchor.constraint(equalTo: suggestionContainerView.trailingAnchor, constant: Styles.grid(-2)),
            suggestionLabel.bottomAnchor.constraint(equalTo: suggestionContainerView.bottomAnchor, constant: Styles.grid(-4)),
            // containerStackView
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Styles.grid(8)),
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Styles.grid(8)),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Styles.grid(-8)),
            containerStackView.bottomAnchor.constraint(equalTo: weekCollectionView.topAnchor, constant: Styles.grid(-8)),
            // lastWeekContainerView
            weekCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weekCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weekCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weekCollectionView.heightAnchor.constraint(equalToConstant: Styles.grid(24))
        ])
    }
}

// MARK: - Private
extension MainViewController {
    private func setNavigation() {
        title = Date.currentDate
        let calendarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.pie"),
                                                              style: .plain,
                                                              target: self,
                                                              action: nil)
        let settingButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(diaryIsWrite))
        navigationItem.rightBarButtonItems = [settingButton, calendarButton]
    }

    @objc
    private func diaryIsWrite() {
        DispatchQueue.main.async {
            self.currentStatusLabel.isHidden.toggle()
            self.currentWeatherView.isHidden.toggle()

            self.contentWriteButton.isHidden.toggle()
            self.contentEditButton.isHidden.toggle()
            self.contentDeleteButton.isHidden.toggle()

            if self.isWrite {
                self.contentTextView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                self.currentWeatherContainerViewHeightAnchor.isActive = true
            } else {
                self.contentTextView.text = "마음의 날씨를 기록해보세요!"
                self.currentWeatherContainerViewHeightAnchor.isActive = true
            }
            self.loadViewIfNeeded()
        }
    }

    private func bindWeekCollectionView() {
        let dumpData: Observable<[String]> = Observable<[String]>.just(Array(1...31).map { String($0) })

        dumpData
            .bind(to: weekCollectionView.rx.items(cellIdentifier: WeekCollectionViewCell.reuseIdentifier, cellType: WeekCollectionViewCell.self)) {  _, element, cell in
                cell.configure(element)
            }
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct MainViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: MainViewController()).toPreview().edgesIgnoringSafeArea(.all)
    }
}
#endif
