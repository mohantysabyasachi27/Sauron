//
//  ProfileIconView.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.//

import Foundation
import UIKit

internal class ProfileIconView: UIImageView {
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 8.0
    self.layer.borderWidth = 3.0
    self.layer.borderColor = UIColor.white.cgColor
    self.clipsToBounds = true
  }
}
