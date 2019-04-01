//
//  Helper.swift
//  TestWeather
//
//  Created by Bao on 3/27/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Helper {
    
    class func callAPI(city: String, completion: @escaping(Bool, Weather) -> Swift.Void) {
        let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
        if let c = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(c)&appid=\(apiKey)&units=metric")!
            Alamofire.request(url).responseJSON{ (response) in
                //            print(response)
                switch response.result{
                //_ = let value
                case .success( _):
                    //                    let json = JSON(value)
                    if let responseStr = response.result.value {
                        let jsonResponse = JSON(responseStr)
                        let cod = jsonResponse["cod"]
                        if cod.stringValue == "200" {
                            let jsonWeather = jsonResponse["weather"].array![0]
                            print(jsonWeather)
                            let jsonTemp = jsonResponse["main"]
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            let dailyModel = Weather(day: dateFormatter.string(from: date) , main: jsonWeather["main"].stringValue, temp:"\(Int(round(jsonTemp["temp"].doubleValue)))", name: jsonResponse["name"].stringValue)
                            completion(true, dailyModel)
                        } else {
                            let dailyModel = Weather()
                            completion(false, dailyModel)
                        }
                        
                    }
                case .failure(let error):
                    let dailyModel = Weather()
                    completion(false, dailyModel)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func fetchJson(city: String, completion: @escaping(Bool, [Weather]) -> Swift.Void){
        var weatherList = [Weather]()
        let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
        if let ct = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(ct)&appid=\(apiKey)&units=metric")!
        Alamofire.request(url).responseJSON{ (response) in
            //            print(response)
            switch response.result{
            //_ = let value
            case .success( _):
                //                    let json = JSON(value)
                if let responseStr = response.result.value {
                    let jsonResponse = JSON(responseStr)
                    //                        print(jsonResponse)
                    let data = jsonResponse["list"]
                    //                                            print(data)
                    data.array?.forEach({ (daily) in
                        let weatherJson = daily["weather"].array![0]
                        let date = Date(timeIntervalSince1970: daily["dt"].doubleValue)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEEE"
                        let main = daily["main"]
                        let calendar = Calendar.current
                        _ = calendar.component(.hour, from: date)
                        
                        let dailyModel = Weather(day: dateFormatter.string(from: date),main: weatherJson["main"].stringValue, time: daily["dt_txt"].stringValue, temp: main["temp"].stringValue)
                        let current_date = Date()
                        _ = calendar.component(.hour, from: current_date)
                        weatherList.append(dailyModel)
                    })
                    completion(true, weatherList)
                } else {
                    completion(false, [Weather]())
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, [Weather]())
            }
            }
        }
    }
    
    class func fetchDay(city: String, completion: @escaping (Bool, [Weather]) -> Swift.Void)  {
        var dayList = [Weather]()
        let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
        if let ct = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(ct)&appid=\(apiKey)&units=metric")!
            Alamofire.request(url).responseJSON { (response) in
                
                switch response.result{
                case .success( _):
                    if let responStr = response.result.value {
                        let jsonResponse = JSON(responStr)
//                        let data = jsonResponse["city"]
//                        let temp = jsonResponse["temp"]
//                        _ = data["name"]
                        let list = jsonResponse["list"]
                        print(list)
//                        let jsonWeather = jsonResponse["weather"].array![0]
                        list.array?.forEach({ (json) in
                            let temp = json["temp"]
                            let weatherJson = json["weather"].array![0]
                            let date = Date(timeIntervalSince1970: json["dt"].doubleValue)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            let weather = Weather(day: dateFormatter.string(from: date),main: weatherJson["main"].stringValue , tempMin: temp["min"].stringValue, temMax: temp["max"].stringValue)
                            print(weather)
                            dayList.append(weather)
                        })
                        completion(true, dayList)
                    }
                    else {
                        completion(false, [Weather]())
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, [Weather]())
                }
            }
        }
    }
}
