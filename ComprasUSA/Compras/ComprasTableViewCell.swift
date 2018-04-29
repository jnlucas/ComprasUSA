//
//  ComprasTableViewCell.swift
//  ComprasUSA
//
//  Created by joao neves on 29/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit

class ComprasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivImage: UIImageView!
    
    @IBOutlet weak var lbNome: UILabel!
    
    @IBOutlet weak var lbPreco: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
