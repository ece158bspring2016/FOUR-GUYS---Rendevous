//
//  Member.swift
//  Rendezvous
//
//  Created by John Law on 14/5/2016.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit

var member_data = [Member(name:"You", eta: nil, mode:"")]

struct Member {
    var name: String?
    var eta: String?
    var mode: String?
    
    init(name: String?, eta: String?, mode: String?) {
        self.name = name
        self.eta = eta
        self.mode = mode
        
    }
}