//
//  ComprasTableViewController.swift
//  ComprasUSA
//
//  Created by joao neves on 28/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import CoreData


class ComprasTableViewController: UITableViewController {

    
    var fetchedResultController: NSFetchedResultsController<Compra>!
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = .black
        
        loadCompras()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CadastrarViewController {
            if let index = tableView.indexPathForSelectedRow {
                vc.compra = fetchedResultController.object(at: index)
            }
        }
        
    }
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "compraCell", for: indexPath) as! ComprasTableViewCell
        let compra = fetchedResultController.object(at: indexPath)
        cell.lbNome.text = compra.nome
        cell.lbPreco.text = "\(compra.preco)"
        
        
        if let image = compra.imagem as? UIImage {
            cell.ivImage.image = image
        } else {
            cell.ivImage.image = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let compra = fetchedResultController.object(at: indexPath)
            context.delete(compra)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: - METHODS
    func loadCompras() {
        let fetchRequest: NSFetchRequest<Compra> = Compra.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}


// MARK: - NSFetchedResultsControllerDelegate
extension ComprasTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
