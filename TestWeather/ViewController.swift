//
//  ViewController.swift
//  TestWeather
//
//  Created by Bao on 3/21/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//import CoreLocation

class ViewController: UIViewController {
    
    //MARK:Property
    @IBOutlet weak var imgSun: UIImageView!
    @IBOutlet weak var lblPlace: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblClounds: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    
    //    let lat = <#value#>
    //    let lon =
    let id = 1562822
    let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
    var weather : [Weather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        parseJson()
        fetchJson()
        
    }
    func parseJson(){
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=21.02&lon=105.84&appid=\(apiKey)&units=metric")!
        Alamofire.request(url).responseJSON{ (response) in
            //            print(response)
            switch response.result{
            //_ = let value
            case .success( _):
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    //                    let json = JSON(value)
                    if let responseStr = response.result.value {
                        let jsonResponse = JSON(responseStr)
                        let jsonWeather = jsonResponse["weather"].array![0]
                        let jsonClound = jsonResponse["main"]
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEEE"
                        //                        print(jsonResponse)
                        self.lblPlace.text = jsonResponse["name"].stringValue
                        self.lblClounds.text = jsonWeather["main"].stringValue
                        self.lblTemp.text = "\(Int(round(jsonClound["temp"].doubleValue)))"
                        self.lblTime.text = dateFormatter.string(from: date)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchJson() {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=\(id)&appid=\(apiKey)&units=metric")!
        Alamofire.request(url).responseJSON{ (response) in
            //            print(response)
            switch response.result{
            //_ = let value
            case .success( _):
                DispatchQueue.main.async {
                    [weak self] in
                    guard self != nil else {return}
                    //                    let json = JSON(value)
                    if let responseStr = response.result.value {
                        let jsonResponse = JSON(responseStr)
                        //                        print(jsonResponse)
                        let data = jsonResponse["list"]
                        //                                            print(data)
                        data.array?.forEach({ (daily) in
                            let date = Date(timeIntervalSince1970: daily["dt"].doubleValue)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            let main = daily["main"]
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            
                            let dailyModel = Weather(day: dateFormatter.string(from: date), time: daily["dt_txt"].stringValue, temp: main["temp"].stringValue)
                            let current_date = Date()
                            let current_hour = calendar.component(.hour, from: current_date)
                            //hour - current_hour <= 3 && hour - current_hour > 0
                            if hour - current_hour > 7{
                                print(hour)
                                self!.weather.append(dailyModel)
                            }
                            
                        })
                    }
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempCell", for: indexPath) as! TableViewCell
        let data = weather[indexPath.row]
        cell.lblDay.text = data.day
        cell.lblTime.text = data.time
        cell.lblTemp.text = data.temp
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
