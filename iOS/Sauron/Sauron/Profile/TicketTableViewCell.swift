//
//  TicketTableViewCell.swift
//  Sauron
//
//  Created by Ishan Sarangi on 11/11/18.
//  Copyright © 2018 Ishan Sarangi. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var subheader: UILabel!
    @IBOutlet weak var statusIV: UIImageView!
    @IBOutlet weak var movIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.movIV.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
