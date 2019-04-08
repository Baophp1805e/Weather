//
//  DayTableViewCell.swift
//  TestWeather
//
//  Created by Bao on 3/28/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var imgSun: UIImageView!
    @IBOutlet weak var lblMax: UILabel!
    @IBOutlet weak var lblMin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(weather: DayWeather){
        
        
        if weather.tempMax != nil{
            lblDay.text = weather.day
            lblMain.text = weather.main
            updateImage(text: weather.main!)
            lblMax.text = weather.tempMax! + " °C"
            lblMin.text = weather.tempMin! + " °C"
        }
        
        
    }
    

    func updateImage(text:String) {
        switch text {
        case "Sunny":
            self.imgSun.image = UIImage(named: "sunny")
        //            break
        case "Clear":
            self.imgSun.image = UIImage(named: "sunny")
        //            break
        case "Clouds":
            self.imgSun.image = UIImage(named: "cloudy2")
        case "Rain":
            self.imgSun.image = UIImage(named: "light_rain")
        case "Thunder":
            self.imgSun.image = UIImage(named: "storm1")
        case "Thunderstorm":
            self.imgSun.image = UIImage(named: "storm2")
        case "Snow":
            self.imgSun.image = UIImage(named: "snow4")
        case "Fog":
            self.imgSun.image = UIImage(named: "fog")
        case "Mist":
            self.imgSun.image = UIImage(named: "fog")
        case "Haze":
            self.imgSun.image = UIImage(named: "fog")
        //            break
        default:
            self.imgSun.image = UIImage(named: "don't_know")
        }
    }
    
    
}
