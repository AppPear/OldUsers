//
//  UserTableViewCell.swift
//  OldUsers
//
//  Created by Samu András on 2019. 09. 17..
//  Copyright © 2019. Samu András. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
  @IBOutlet weak var fullName: UILabel!
  @IBOutlet weak var emailAddress: UILabel!
  @IBOutlet weak var userImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.userImageView.layer.cornerRadius = 35
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
