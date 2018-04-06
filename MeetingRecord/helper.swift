//
//  helper.swift
//  MeetingRecord
//
//  Created by nics1094 on 2018/02/20.
//  Copyright © 2018年 nics1094. All rights reserved.
//

import UIKit

class helper: NSObject {
    //nics0907
//    var api = "http://172.16.20.51:7001/"
    //nics0992
         var api = "http://172.16.20.55:7001/"
    //sfc_dev
//        var api = "http://192.168.223.80:7003/"
    //sfc_prd
    //    var api = "http://192.168.223.52:7003/"

}
struct MdUtils {
    ///
    static func getAuthHeader() -> Dictionary<String, String> {
        var auth_header = [ "Authorization" : "" ]
        if let a :String = UserDefaults.standard.string(forKey: "TokenStr"){
             auth_header = [ "Authorization" : a ]
        }else{
             auth_header = [ "Authorization" : "no customer" ]
        }
        return auth_header
    }
}
