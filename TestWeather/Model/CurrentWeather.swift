//
//  CurrentWeather.swift
//  TestWeather
//
//  Created by Bao on 4/5/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation

class CurrentWeather {
    
    var name: String?
    var time: String?
    var temp: String?
    var main: String?
    
    init(name:String, time: String ,temp:String, main:String) {
        self.name = name
        self.time = time
        self.temp = temp
        self.main = main
    }
    
    func toRealm() -> RlmCurrentWeather {
        let rlmWeather = RlmCurrentWeather(name: self.name!, time: self.time!, temp: self.temp!, main: self.main!)
        return rlmWeather
    }
    
}
