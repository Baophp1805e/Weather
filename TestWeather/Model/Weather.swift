//
//  WeatherModel.swift
//  TestWeather
//
//  Created by Bao on 3/22/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation

struct Weather {
    var name:String?
    var day:String?
    var time:String?
    var temp:String?
    var main:String?
    
    init(day:String, time:String, temp:String) {
        self.day = day
        self.time = time
        self.temp = temp
    }
    init(day:String, main:String, temp:String, name:String) {
        self.day = day
        self.main = main
        self.temp = temp
        self.name = name
    }
    
    init() {
        self.day = ""
        self.main = ""
        self.temp = ""
        self.name = ""
    }
}

