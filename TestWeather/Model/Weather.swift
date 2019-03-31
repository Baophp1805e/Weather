//
//  WeatherModel.swift
//  TestWeather
//
//  Created by Bao on 3/22/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation

struct Weather {
    var name: String?
    var day: String?
    var time: String?
    var temp: String?
    var main: String?
    var tempMin: String?
    var temMax: String?
    var timeStamp: String?
    
    
    init(day:String, main: String ,time:String, temp:String) {
        self.day = day
        self.time = time
        self.temp = temp
        self.main = main
    }
    init(day:String, main:String, temp:String, name:String) {
        self.day = day
        self.main = main
        self.temp = temp
        self.name = name
    }
    
    init(day:String, main:String, tempMin:String, temMax:String) {
        self.day = day
        self.main = main
        self.tempMin = tempMin
        self.temMax = temMax
    }
    
    init() {
        self.day = ""
        self.main = ""
        self.temp = ""
        self.name = ""
    }
    
}

