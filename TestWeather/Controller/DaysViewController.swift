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

class DaysViewController: UIViewController, UISearchBarDelegate, NVActivityIndicatorViewable {
    
    var weatherList = [Weather]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "dayCell")
//        getCity(city: "Ha Noi")
//        activityIndicatorView.startAnimating()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            getCity(city: searchText)
        } else {
            getCity(city: "Ha Noi")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let _ = Connectivity.isConnectedToInternet
        do {
            if Connectivity.isConnectedToInternet {
                getCity(city: "Ha Noi")
                lblError.text = "The next 7 days"
                self.tableView.reloadData()
            } else {
                clearData()
            }
        }
    }
    func clearData(){
        lblError.text = "No Internet, try again!"
        self.weatherList.removeAll()
         self.tableView.reloadData()
    }
    
    func customTable(){
//        NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
    }
    
    func getCity(city: String){
        Helper.fetchDay(city: city) { [weak self] success, weatherDay in
            self?.weatherList = weatherDay
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
     //func searchBar(city: String, textDidChange)

}

extension DaysViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayTableViewCell
        let data = weatherList[indexPath.row]
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
