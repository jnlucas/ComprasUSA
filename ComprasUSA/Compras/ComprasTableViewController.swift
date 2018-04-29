//
//  ComprasTableViewController.swift
//  ComprasUSA
//
//  Created by joao neves on 28/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit

class ComprasTableViewController: UITableViewController {

    @IBOutlet weak var lbCompras: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbCompras.text = "Sem compras"
        
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    

}
