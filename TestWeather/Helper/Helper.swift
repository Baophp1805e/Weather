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
    
    class func getCurrentWeatherAPI(forName city: String, completion: @escaping(Bool, CurrentWeather) -> Swift.Void) {
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
                            let dailyModel = CurrentWeather(name: jsonResponse["name"].stringValue, time: dateFormatter.string(from: date) , temp:"\(Int(round(jsonTemp["temp"].doubleValue)))", main: jsonWeather["main"].stringValue )
                            completion(true, dailyModel)
                        } else {
                            let dailyModel = CurrentWeather(name: "", time: "", temp: "", main: "")
                            completion(false, dailyModel)
                        }
                        
                    }
                case .failure(let error):
                    let dailyModel = CurrentWeather(name: "", time: "", temp: "", main: "")
                    completion(false, dailyModel)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func getWeatherListHourAPI(forName city: String, completion: @escaping(Bool, [HourWeather]) -> Swift.Void){
        var weatherList = [HourWeather]()
        let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
        if let ct = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(ct)&appid=\(apiKey)&units=metric")!
        Alamofire.request(url).responseJSON{ (response) in
            //            print(response)
            switch response.result{
            case .success( _):
                if let responseStr = response.result.value {
                    let jsonResponse = JSON(responseStr)
                    //                        print(jsonResponse)
                    let data = jsonResponse["list"]
                    data.array?.forEach({ (daily) in
                        
                        let weatherJson = daily["weather"].array![0]
                        let mainTemp = daily["main"]
                        
                        let name = daily["name"].stringValue
                        let day = daily["dt"].intValue
                        let time = daily["dt_txt"].stringValue
                        let temp = mainTemp["temp"].stringValue
                        let main = weatherJson["main"].stringValue
                        
                        let dailyModel = HourWeather(name: name, day: day, time: time, temp: temp, main: main)
                        weatherList.append(dailyModel)
                    })
                    completion(true, weatherList)
                } else {
                    completion(false, [HourWeather]())
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, [HourWeather]())
            }
            }
        }
    }
    
    class func getWeatherListDayAPI(forName city: String, completion: @escaping (Bool, [DayWeather]) -> Swift.Void)  {
        var dayList = [DayWeather]()
        let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
        if let ct = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(ct)&appid=\(apiKey)&units=metric")!
            Alamofire.request(url).responseJSON { (response) in
                
                switch response.result{
                case .success( _):
                    if let responStr = response.result.value {
                        let jsonResponse = JSON(responStr)
                        let list = jsonResponse["list"]
                        print(list)
//                        let jsonWeather = jsonResponse["weather"].array![0]
                        list.array?.forEach({ (json) in
                            let temp = json["temp"]
                            let name = json["name"]
                            let weatherJson = json["weather"].array![0]
                            let date = Date(timeIntervalSince1970: json["dt"].doubleValue)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            let weather = DayWeather(name: name.stringValue, day: dateFormatter.string(from: date),tempMin: temp["min"].stringValue, tempMax: temp["max"].stringValue, main: weatherJson["main"].stringValue)
                            print(weather)
                            dayList.append(weather)
                        })
                        completion(true, dayList)
                    }
                    else {
                        completion(false, [DayWeather]())
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false, [DayWeather]())
                }
            }
        }
    }
}
