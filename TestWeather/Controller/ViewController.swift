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
    var weather = [Weather]()
    var refreshControl = UIRefreshControl()
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.headerView(forSection: 1)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        refreshTablebiew()
    }
    
    //MARK: Handling
    
    func refreshTablebiew(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(sender:AnyObject) {
            request(city: "Ha Noi")
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            request(city: searchText)
        } else {
            request(city: "Ha Noi")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let _ = Connectivity.isConnectedToInternet
        do {
                if Connectivity.isConnectedToInternet {
                    request(city: "Ha Noi")
                    let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd HH:mm"
                    let formattedDate = format.string(from: date)
                    currentTime.text = formattedDate
                    lblError.text = "3 day forecast"
                    self.tableView.reloadData()
                } else {
                    clearData()
                }
        }
    }
    func clearData(){
        let a = "No Internet,try again!"
        let b = ""
        lblError.text = a
        currentTime.text = b
        imgMain.image = UIImage(named: "don't_know")
        self.lblTime.text = ""
        self.lblPlace.text = ""
        self.lblClounds.text = ""
        self.lblTemp.text = ""
        self.weather.removeAll()
        self.tableView.reloadData()
    }
    func request(city:String){
        
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "Loading", type: NVActivityIndicatorType.ballRotateChase, fadeInAnimation: nil)
        Helper.callAPI(city: city) { [weak self] success, weather in
            guard let `self` = self else {return}
            self.refreshControl.endRefreshing()
            if success {
                DispatchQueue.main.async {
                    self.lblTime.text = weather.day
                    self.lblPlace.text = weather.name
                    self.lblClounds.text = weather.main
                    self.updateImage(text: weather.main!)
                    self.lblTemp.text = weather.temp! + " °C"
                    let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd HH:mm"
                    let formattedDate = format.string(from: date)
                    self.currentTime.text = formattedDate
                    self.lblError.text = "3 day forecast"
                    self.stopAnimating()
                }
            } else {
                self.stopAnimating()
                print("Error")
            }
            
        }
        Helper.fetchJson(city: city) { [weak self] success, weatherList in
            if success {
                self?.weather = weatherList
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self!.stopAnimating()
                }
            } else {
                self!.stopAnimating()
                print("Error")
            }
        }
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
