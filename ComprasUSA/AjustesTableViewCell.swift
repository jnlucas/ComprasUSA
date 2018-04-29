//
//  AjustesTableViewCell.swift
//  ComprasUSA
//
//  Created by joao neves on 28/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit

class AjustesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lbCelEstado: UILabel!
    @IBOutlet weak var lbCelImposto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
