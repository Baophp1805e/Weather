//
//  DaysWeather.swift
//  TestWeather
//
//  Created by Bao on 4/5/19.
//  Copyright © 2019 Bao. All rights reserved.
//


import Foundation
import RealmSwift

class RlmDayWeather: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var day: String?
    @objc dynamic var tempMin: String?
    @objc dynamic var tempMax: String?
    @objc dynamic var main: String?
    
    convenience init(name: String, day: String, tempMin: String, tempMax: String, main: String) {
        self.init()
        self.name = name
        self.day = day
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.main = main
    }
    
    func toModel() -> DayWeather {
        let weather = DayWeather(name: self.name!, day: self.day!, tempMin: self.tempMin!, tempMax: self.tempMax!, main: self.main!)
        return weather
    }
}

