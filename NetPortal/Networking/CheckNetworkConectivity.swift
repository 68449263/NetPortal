//
//  CheckNetworkConectivity.swift
//  NetPortal
//
//  Created by Siyabonga Zondo on 2018/02/07.
//  Copyright © 2018 Siyabonga Zondo. All rights reserved.
//


import Foundation
import Alamofire

public class CheckNetworkConectivity{

    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
