//
//  CurrentWeatherView.swift
//  WeatherMood
//
//  Created by 이지원 on 2021/07/28.
//

import UIKit

final class CurrentWeatherView: UIView, Viewable {
    // MARK: - View Properties
    private let locationIconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "location")
        return imageView
    }()

    /// nickname + 님의 하늘
    private let descriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "현수님의 하늘"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()

    private let currentTemperatureView: CurrentTemperatureView = {
        let tempView: CurrentTemperatureView = CurrentTemperatureView()
        tempView.translatesAutoresizingMaskIntoConstraints = false
        return tempView
    }()

    /// 불쾌 지수
    private let discomfortIndexView: VerticalIconTextView = {
        let view: VerticalIconTextView = VerticalIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 습도
    private let humidityView: VerticalIconTextView = {
        let view: VerticalIconTextView = VerticalIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 풍량
    private let airVolumnView: VerticalIconTextView = {
        let view: VerticalIconTextView = VerticalIconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupViews() {
        let descriptionStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [locationIconImageView, descriptionLabel])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.spacing = Styles.grid(2)
            return stackView
        }()

        let otherInformationStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [discomfortIndexView, humidityView, airVolumnView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = Styles.grid(12)
            return stackView
        }()

        let containerStackView: UIStackView = {
            let stackView: UIStackView = UIStackView(arrangedSubviews: [descriptionStackView, currentTemperatureView, otherInformationStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            stackView.spacing = Styles.grid(4)
            return stackView
        }()

        self.addSubview(containerStackView)

        NSLayoutConstraint.activate([
            locationIconImageView.heightAnchor.constraint(equalTo: locationIconImageView.widthAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

struct CurrentWeatherViewPreview: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView().toPreview()
    }
}
#endif
