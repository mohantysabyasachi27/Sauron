//
//  TwitterProfileHeaderView.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/10/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.//

import Foundation
import UIKit

protocol TwitterProfileHeaderViewDelegate: class {
    func didTapOnReportButton()
    func refreshData()
}

class TwitterProfileHeaderView: UIView {
  @IBOutlet weak var iconHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: TwitterProfileHeaderViewDelegate?

  let maxHeight: CGFloat = 100
  let minHeight: CGFloat = 80
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.iconHeightConstraint.constant = maxHeight

  }
  
  func animator(t: CGFloat) {
//    print(t)
    
    if t < 0 {
      iconHeightConstraint.constant = maxHeight
      return
    }
    
    let height = max(maxHeight - (maxHeight - minHeight) * t, minHeight)
    
    iconHeightConstraint.constant = height
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    descriptionLabel.sizeToFit()
    let bottomFrame = descriptionLabel.frame
    let iSize = descriptionLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    let resultSize = CGSize.init(width: size.width, height: bottomFrame.origin.y + iSize.height)
    return resultSize
  }
    @IBAction func didPressReport(_ sender: Any) {
        self.delegate?.didTapOnReportButton()
    }
    @IBAction func didpressRefresh(_ sender: Any) {
        self.delegate?.refreshData()
    }
}
