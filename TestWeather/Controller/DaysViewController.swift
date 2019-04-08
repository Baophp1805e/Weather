//
//  DaysViewController.swift
//  TestWeather
//
//  Created by Bao on 3/28/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import RealmSwift

class DaysViewController: UIViewController, UISearchBarDelegate, NVActivityIndicatorViewable {
    
    //MARK: Properties
    var dayWeatherList = [DayWeather]()
    let realm = try! Realm()
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "dayCell")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            getWeatherListDayAPI(city: searchText)
        } else {
            getWeatherListDayAPI(city : "Ha Noi")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let _ = Connectivity.isConnectedToInternet
        do {
            if Connectivity.isConnectedToInternet {
                getWeatherListDayAPI(city: "Ha Noi")
                lblError.text = "The next 7 days"
                self.tableView.reloadData()
            } else {
                clearData()
            }
        }
    }
    
    func clearData(){
        lblError.text = "No Internet, try again!"
        self.dayWeatherList.removeAll()
        self.tableView.reloadData()
        getCacheData()
    }
    
    func getWeatherListDayAPI(city: String){
        Helper.getWeatherListDayAPI(forName: city) { [weak self] success, weatherDay in
             guard let `self` = self else {return}
            self.dayWeatherList = weatherDay
            //Realm
           self.saveWeatherListDayCache(weather: self.dayWeatherList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    //MARK: Realm
    func saveWeatherListDayCache(weather: [DayWeather]){
        let item = self.realm.objects(RlmDayWeather.self)
        try! self.realm.write() {
            self.realm.delete(item)
        }
        dayWeatherList.forEach({ (weather) in
            try! self.realm.write() {
                self.realm.add(weather.toRealm())
            }
        })
    }
    func getCacheData(){
        let infors = self.realm.objects(RlmDayWeather.self)
        for infor in infors{
            self.dayWeatherList.append(infor.toModel())
        } 
        self.tableView.reloadData()
    }
}

//MARK: Collection Views
extension DaysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayTableViewCell       
        let data = dayWeatherList[indexPath.row]
        cell.setData(weather: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
