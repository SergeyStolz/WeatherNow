//
//  WeaterNowViewController.swift
//  Weather Now
//
//  Created by mac on 05.10.2021.
//

import UIKit
import CoreLocation

class WeaterNowViewController: UIViewController, CLLocationManagerDelegate {
    
    let color = UIColor(named: "infoColor")
    var networkWeatherManager = NetworkWeatherManager()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "nosign")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.text = "0.0"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.text = "°C"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.text = "0.0"
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var feelsLikeTextLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.textAlignment = .center
        label.text = "Feels like:"
        label.font = UIFont(name: "Arial", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = color
        label.textAlignment = .center
        label.text = "To start using the app, click on search in the lower right corner"
        label.font = UIFont(name: "Arial", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 45, weight: .light, scale: .default)
        let image = UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: config)
        button.tintColor = color
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    @objc private func searchPressed(_ sender: UIButton) {
        notificationLabel.removeFromSuperview()
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkWeatherManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
    
    private func updateInterfaceWith(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
    
    private func setupViews() {
        let img: UIImage = UIImage(named: "background")!
        view.layer.contents = img.cgImage
        
        view.addSubview(weatherIconImageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(feelsLikeLabel)
        view.addSubview(searchButton)
        view.addSubview(temperatureTextLabel)
        view.addSubview(feelsLikeTextLabel)
        view.addSubview(notificationLabel)
        
        NSLayoutConstraint.activate([
            weatherIconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -245),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 250),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 3),
            temperatureLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 155),
            temperatureLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            temperatureTextLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 3),
            temperatureTextLabel.leftAnchor.constraint(equalTo: temperatureLabel.rightAnchor, constant: 5),
            temperatureTextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            temperatureTextLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            feelsLikeLabel.topAnchor.constraint(equalTo: temperatureTextLabel.bottomAnchor, constant: 5),
            feelsLikeLabel.leftAnchor.constraint(equalTo: feelsLikeTextLabel.rightAnchor, constant: 5),
            feelsLikeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            feelsLikeLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            feelsLikeTextLabel.topAnchor.constraint(equalTo: temperatureTextLabel.bottomAnchor, constant: 5),
            feelsLikeTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 155),
            feelsLikeTextLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            feelsLikeTextLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            notificationLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            notificationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationLabel.widthAnchor.constraint(equalToConstant: 250),
            notificationLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: -20),
            cityLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            cityLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            cityLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkWeatherManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
