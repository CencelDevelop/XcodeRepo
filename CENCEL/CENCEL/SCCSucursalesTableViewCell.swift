//
//  SCCSucursalesTableViewCell.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 01/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCSucursalesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTiendaNombre: UILabel!
    @IBOutlet weak var lblTiendaCodigo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
