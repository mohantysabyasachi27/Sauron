//
//  RoundButton.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import Foundation
import UIKit

internal class RoundButton: UIButton {
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.borderWidth = 1.0
    self.layer.borderColor = TwitterProfileViewController.globalTint.cgColor
    self.layer.cornerRadius = 4.0
  }
}
