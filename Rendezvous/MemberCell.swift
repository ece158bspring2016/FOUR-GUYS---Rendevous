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
    @IBOutlet weak var transport_image: UIImageView!
    
    var member: Member! {
        didSet {
            title_label.text = member.name
            eta_label.text = member.eta
            transport_image.image = imageForTransport(dataService.desiredModeString)
        }
    }
    
    func configureCell(member: Member) {
        self.member = member
        
        // Set the labels
        self.title_label.text = member.name!
        self.eta_label.text = member.eta!
    }

    func imageForTransport(transport:String) -> UIImage? {
        return UIImage(named: transport)
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
