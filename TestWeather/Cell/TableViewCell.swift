//
//  TableViewCell.swift
//  TestWeather
//
//  Created by Bao on 3/22/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(wether:Weather) {
        lblDay.text = wether.day
        lblTime.text = wether.time
        lblTemp.text = wether.temp
        
        updateImage(text: wether.main! )
    }
    
    func updateImage(text:String) {
        switch text {
        case "Sunny":
            self.imgBackground.image = UIImage(named: "sunny")
        //            break
        case "Clear":
            self.imgBackground.image = UIImage(named: "sunny")
        //            break
        case "Clouds":
            self.imgBackground.image = UIImage(named: "cloudy2")
        case "Rain":
            self.imgBackground.image = UIImage(named: "light_rain")
        case "Thunder":
            self.imgBackground.image = UIImage(named: "storm1")
        case "Thunderstorm":
            self.imgBackground.image = UIImage(named: "storm2")
        case "Snow":
            self.imgBackground.image = UIImage(named: "snow4")
        case "Fog":
            self.imgBackground.image = UIImage(named: "fog")
        case "Mist":
            self.imgBackground.image = UIImage(named: "fog")
        case "Haze":
            self.imgBackground.image = UIImage(named: "fog")
        //            break
        default:
            self.imgBackground.image = UIImage(named: "don't_know")
        }
    }
}
