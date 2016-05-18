//
//  EventCell.swift
//  Rendezvous
//
//  Created by David Serrano on 5/16/16.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var event_name_label: UILabel!
    @IBOutlet weak var sender_label: UILabel!
    
    var event: Event! {
        didSet {
            event_name_label.text = event.event_name
            sender_label.text = event.sender
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
