//
//  DayWeather.swift
//  TestWeather
//
//  Created by Bao on 4/5/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation

class DayWeather{
    
    var name    : String?
    var day     : String?
    var tempMin : String?
    var tempMax : String?
    var main    : String?
    
    init(name:String, day:String, tempMin:String, tempMax:String, main: String) {
        self.name    = name
        self.day     = day
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.main    = main
    }
    
    func toRealm() -> RlmDayWeather {
        let rlmWeather = RlmDayWeather(name: self.name!, day: self.day!, tempMin: self.tempMin!, tempMax: self.tempMax!, main: self.main!)
        return rlmWeather
    }
    
}
