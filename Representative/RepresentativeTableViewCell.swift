//
//  RepresentativeTableViewCell.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class RepresentativeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateWithRepresentative(representative: Representative) {
        
        nameLabel.text = representative.name
        partyLabel.text = representative.party
        districtLabel.text = "District \(representative.district)"
        websiteLabel.text = representative.link
        phoneLabel.text = representative.phone

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
