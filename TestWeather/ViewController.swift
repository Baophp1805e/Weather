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

class ViewController: UIViewController, UISearchBarDelegate {
    
    //MARK:Property
    @IBOutlet weak var imgSun: UIImageView!
    @IBOutlet weak var lblPlace: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblClounds: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
//    let id = 1562822
//    let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
    var weather = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tempCell")
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Helper.requestAPI(city: searchText) { [ weak self] weather in
            DispatchQueue.main.async {
                self!.lblTime.text = weather.day
                self!.lblPlace.text = weather.name
                self!.lblClounds.text = weather.main
                self!.lblTemp.text = weather.temp! + " °C"
            }
        }
        Helper.fetchJson(city: searchText) { [weak self] weatherList in
            self?.weather = weatherList
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
        cell.bindData(wether: weather[indexPath.row])

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
