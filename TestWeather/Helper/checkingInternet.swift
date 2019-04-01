//
//  checkingInternet.swift
//  TestWeather
//
//  Created by Bao on 4/1/19.
//  Copyright © 2019 Bao. All rights reserved.
//

import Foundation
import Alamofire

    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
            
        }
    }
    
