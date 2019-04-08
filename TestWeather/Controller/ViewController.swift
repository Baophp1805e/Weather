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
import RealmSwift

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
    var currentWeather: CurrentWeather?
    let realm = try! Realm()
    var weatherList = [HourWeather]()
    
    var refreshControl = UIRefreshControl()
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkOffline()
    }
    
    //MARK: Handling
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        refreshTablebiew()
    }
    
    //MARK: Pull to refresh
    func refreshTablebiew(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(sender:AnyObject) {
        self.getCurrentWeatherAPI(forName: "Ha Noi")
        self.getHourWeatherAPI(forName: "Ha Noi")
        checkOffline()
    }
    
    //MARK: Searching city
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.getCurrentWeatherAPI(forName: searchText)
            self.getHourWeatherAPI(forName: searchText)
        } else {
            self.getCurrentWeatherAPI(forName: "Ha Noi")
            self.getHourWeatherAPI(forName: "Ha Noi")
        }
        
    }
   
    //MARK: Checking Internet
    func checkOffline(){
        let _ = Connectivity.isConnectedToInternet
        do {
            if Connectivity.isConnectedToInternet {
//                searchBar.isHidden = false
                let size = CGSize(width: 30, height: 30)
                self.startAnimating(size, message: "Loading", type: NVActivityIndicatorType.ballRotateChase, fadeInAnimation: nil)
                self.getCurrentWeatherAPI(forName: "Ha Noi")
                self.getHourWeatherAPI(forName: "Ha Noi")
                self.lblError.text = "3 day Forecast"
                self.stopAnimating()
            } else {
//                searchBar.isHidden = true
                self.lblError.text = "No Internet, try again!"
                self.getCurrentWeatherCache()
                self.getHourWeatherCache()
            }
        }
    }
    
    //MARK: GetCurrentWeatherAPI
    func getCurrentWeatherAPI(forName city: String){
        Helper.getCurrentWeatherAPI(forName: city) { [weak self] success, weather in
            guard let `self` = self else {return}
            self.refreshControl.endRefreshing()
            if success {
                DispatchQueue.main.async {
                    self.currentWeather = weather
                    self.setupTopView()
                    self.saveCurrentWeatherCache(weather: self.currentWeather!)
                }
            } else {
                print("Error")
            }
        }
    }
    
    //MARK: Handle View CurrentWeatherAPI
    func setupTopView(){
        self.lblTime.text = currentWeather!.time
        self.lblPlace.text = currentWeather!.name
        self.lblClounds.text = currentWeather!.main
        self.updateImage(text: currentWeather!.main!)
        self.lblTemp.text = currentWeather!.temp! + " °C"
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: date)
        self.currentTime.text = formattedDate
//        self.lblError.text = "3 day forecast"
    }
    
    //MARK: GetHourWeatherAPI
    func getHourWeatherAPI(forName city: String){
        Helper.getWeatherListHourAPI(forName: city) { [weak self] success, weatherList in
            guard let `self` = self else {return}
            self.refreshControl.endRefreshing()
            if success {
                self.weatherList = weatherList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.saveWeatherListHourCache(weather: self.weatherList)
            } else {
                self.stopAnimating()
                print("Error")
            }
        }
    }
    
    //MARK: Realm
    func saveWeatherListHourCache(weather: [HourWeather]){
        let item = realm.objects(RlmHourWeather.self)
        try! realm.write() {
            self.realm.delete(item)
        }
        weatherList.forEach({ (weather) in
            try! realm.write() {
                self.realm.add(weather.toRealm())
            }
        })
    }
    
    func saveCurrentWeatherCache(weather: CurrentWeather){
        let item = realm.objects(RlmCurrentWeather.self)
        try! realm.write() {
            self.realm.delete(item)
            self.realm.add(weather.toRealm())
        }
    }
   
    func getCurrentWeatherCache(){
        guard let item = realm.objects(RlmCurrentWeather.self).first else {return}
        self.currentWeather = item.toModel()
        self.setupTopView()
    }
    
    func getHourWeatherCache(){
        let items = realm.objects(RlmHourWeather.self)
        for item in items {
            self.weatherList.append(item.toModel())
        }
        self.tableView.reloadData()
    }
    
    //MARK: Updating image
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
        default:
            self.imgMain.image = UIImage(named: "don't_know")
        }
    }
    
}

//MARK: Collection Views
extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempCell", for: indexPath) as! TableViewCell
        cell.bindData(wether: weatherList[indexPath.row])
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
