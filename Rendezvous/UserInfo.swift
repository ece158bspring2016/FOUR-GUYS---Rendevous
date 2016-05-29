//
//  UserInfo.swift
//  Rendezvous
//
//  Created by John Law on 28/5/2016.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

var user_name:String = ""
var user_uid:String = ""

var user_info: UserInfo!

class UserInfo {
    private var user_name:String = ""
    private var user_uid:String = ""
    
    var getName:String {
        return self.user_name
    }
    
    func setName(name: String) {
        self.user_name = name
    }
    
    var getUID: String {
        return self.user_uid
    }
    
    func setUID(uid: String) {
        self.user_uid = uid
    }
    
    init(name: String, uid: String) {
        self.user_name = name
        self.user_uid = uid
    }    
}