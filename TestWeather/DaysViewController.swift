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

class DaysViewController: UIViewController, UISearchBarDelegate {
    
    var weatherList = [Weather]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "DayTableViewCell", bundle: nil), forCellReuseIdentifier: "dayCell")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Helper.fetchDay(city: searchText) { [weak self] weatherDay in
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
}
