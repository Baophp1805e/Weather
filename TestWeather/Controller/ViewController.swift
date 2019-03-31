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
import NVActivityIndicatorView
//import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, NVActivityIndicatorViewable {
    
    //MARK:Property
    @IBOutlet weak var imgSun: UIImageView!
    @IBOutlet weak var lblPlace: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblClounds: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var weatherModel: Weather?
//    let id = 1562822
//    let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
    var weather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.headerView(forSection: 1)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        //        updateImage()
        request(city: "Ha Noi")
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: date)
        currentTime.text = formattedDate
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            request(city: searchText)
        } else {
            request(city: "Ha Noi")
        }
        
    }
    
    
    func request(city:String){
        
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading", type: NVActivityIndicatorType.ballRotateChase, fadeInAnimation: nil)
        Helper.requestAPI(city: city) { [ weak self] weather in
            DispatchQueue.main.async {
                self!.lblTime.text = weather.day
                self!.lblPlace.text = weather.name
                self!.lblClounds.text = weather.main
                self!.updateImage(text: weather.main!)
                
                self!.lblTemp.text = weather.temp! + " °C"
            }
        }
        Helper.fetchJson(city: city) { [weak self] weatherList in
            self?.weather = weatherList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
//        Helper.fetchDay(city: city) { [weak self] weatherDay in
//            self?.weather = weatherDay
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
        self.stopAnimating()
    }
    
    func updateImage(text:String) {
        switch text {
        case "Sunny":
            self.imgMain.image = UIImage(named: "sunny")
//            break
        case "Clear":
            self.imgMain.image = UIImage(named: "sunny")
//            break
        case "Clouds":
            self.imgMain.image = UIImage(named: "cloudy2")
        case "Rain":
            self.imgMain.image = UIImage(named: "light_rain")
        case "Thunder":
            self.imgMain.image = UIImage(named: "storm1")
        case "Thunderstorm":
            self.imgMain.image = UIImage(named: "storm2")
        case "Snow":
            self.imgMain.image = UIImage(named: "snow4")
        case "Fog":
            self.imgMain.image = UIImage(named: "fog")
        case "Mist":
            self.imgMain.image = UIImage(named: "fog")
        case "Haze":
            self.imgMain.image = UIImage(named: "fog")
//            break
        default:
            self.imgMain.image = UIImage(named: "don't_know")
        }
    }
    
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempCell", for: indexPath) as! TableViewCell
        cell.bindData(wether: weather[indexPath.row])

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
}
