//
//  CurrentTemperatureView.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/28.
//

import UIKit

final class CurrentTemperatureView: UIStackView, Viewable {
    // MARK: - View Properties
    private let weatherIconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "sun.max")
        return imageView
    }()

    private let temperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "19º"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()

    private let compareYesterdayTemperatureLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "어제보다 5º 낮네요"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        setupViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure() {
        axis = .horizontal
        distribution = .fill
        alignment = .center
        spacing = Styles.grid(2)
    }

    func setupViews() {
        let tempStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [temperatureLabel, compareYesterdayTemperatureLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = Styles.grid(2)
            return stackView
        }()

        addArrangedSubview(weatherIconImageView)
        addArrangedSubview(tempStackView)

        NSLayoutConstraint.activate([
            weatherIconImageView.widthAnchor.constraint(equalToConstant: Styles.grid(8)),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
    }
}
