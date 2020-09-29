//
//  API.swift
//  lesson_18
//
//  Created by Oleksandr Karpenko on 29.09.2020.
//

import Foundation
import Magics

class API: MagicsAPI {
    
    static let shared = API()
    
    override var baseURL: String {
        get {
            return "https://test.io"
        }
        set {
            super.baseURL = newValue
        }
    }
    
}

class WeatherInteractor: NSObject, MagicsInteractor {
    
    static let shared = WeatherInteractor()
    
    var api: MagicsAPI { return API.shared }
    var relativeURL: String { return "api/weather" }
    
    var method: MagicsMethod { return .get }
    
    @objc dynamic var weather: WeatherModel?
    
    func process(key: String?, json: MagicsJSON, api: MagicsAPI) {
        weather = api.objectFrom(json: json)
    }
    
}

final class WeatherModel: NSObject, MagicsModel {
    @objc dynamic var cod = ""
    @objc dynamic var eightDays: [WeatherEightDays] = []
}

final class WeatherEightDays: NSObject, MagicsModel {
    @objc dynamic var temperature = ""
    @objc dynamic var wind = ""
    @objc dynamic var rain = ""
}
