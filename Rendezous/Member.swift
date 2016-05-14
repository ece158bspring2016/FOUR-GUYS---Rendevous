//
//  Member.swift
//  Rendezvous
//
//  Created by John Law on 14/5/2016.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit

var member_data = [Member(name:"You", eta: nil)]

struct Member {
    var name: String?
    var eta: String?
    
    init(name: String?, eta: String?) {
        self.name = name
        self.eta = eta
    }
}