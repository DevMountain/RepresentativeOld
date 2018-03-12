//
//  RepresentativeTableViewCell.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class RepresentativeTableViewCell: UITableViewCell {
	
	override func prepareForReuse() {
		super.prepareForReuse()
		representative = nil
	}
	
    private func updateViews() {
		
		guard let representative = representative else { return }
        
        nameLabel.text = representative.name
        partyLabel.text = representative.party
        districtLabel.text = "District \(representative.district)"
        websiteLabel.text = representative.link
        phoneLabel.text = representative.phone

    }

	// MARK: Properties
	
	var representative: Representative? {
		didSet {
			updateViews()
		}
	}
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var partyLabel: UILabel!
	@IBOutlet weak var districtLabel: UILabel!
	@IBOutlet weak var websiteLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
}
