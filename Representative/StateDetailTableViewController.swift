//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Caleb Hicks on 5/3/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let state = state {
			
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
			
			representativeController.searchRepresentatives(forState: state) { (representatives) in
				
				self.representatives = representatives
				
				DispatchQueue.main.async {
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
				}
			}
		}
	}
	
	// MARK: UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {		
		return representatives.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "representativeCell", for: indexPath) as? RepresentativeTableViewCell ?? RepresentativeTableViewCell()
		
		cell.representative = representatives[indexPath.row]
		
		return cell
	}
	
	// MARK: Properties
	
	var state: String?
	var representatives: [Representative] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView?.reloadData()
			}
		}
	}
	
	private let representativeController = RepresentativeController()
}
