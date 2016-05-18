//
//  MemberCell.swift
//  Rendezvous
//
//  Created by John Law on 14/5/2016.
//  Copyright © 2016 FOUR GUYS. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var eta_label: UILabel!
    
    var member: Member! {
        didSet {
            title_label.text = member.name
            eta_label.text = member.eta
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
