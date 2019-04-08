//
//  HourWeather.swift
//  TestWeather
//
//  Created by Bao on 4/5/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation

class HourWeather {
    
    var name: String?
    var day: Int?
    var time: String?
    var temp: String?
    var main: String?
    
    init(name:String, day : Int, time:String, temp:String, main: String) {
        self.name = name
        self.day  = day
        self.time = time
        self.temp = temp
        self.main = main
    }
    
    func toRealm() -> RlmHourWeather {
        let rlmWeather = RlmHourWeather(name: self.name!, day: self.day!, time: self.time!, temp: self.temp!, main: self.main!)
        return rlmWeather
    }

    
}
