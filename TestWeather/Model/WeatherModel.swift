//
//  WeatherModel.swift
//  TestWeather
//
//  Created by Bao on 3/22/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation

struct Weather {
    var day:String?
    var time:String?
    var temp:String?
    
    init(day:String, time:String, temp:String) {
        self.day = day
        self.time = time
        self.temp = temp
    }
}
