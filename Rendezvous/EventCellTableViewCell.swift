//
//  EventCellTableViewCell.swift
//  Rendezvous
//
//  Created by David Serrano on 5/19/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Firebase

class EventCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var senderName: UILabel!
    
    var event: Event!
    var eventRef: Firebase!
    
    func configureCell(event: Event) {
        self.event = event
        
        // Set the labels
        self.eventName.text = event.eventName
        self.senderName.text = event.senderName
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
