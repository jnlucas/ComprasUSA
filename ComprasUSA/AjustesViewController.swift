//
//  AjustesViewController.swift
//  ComprasUSA
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import CoreData

enum EstadoType {
    case add
    case edit
}

class AjustesViewController: UIViewController {

    @IBOutlet weak var txtCotacao: UITextField!
    @IBOutlet weak var txtIOF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    
    var fetchedResultController: NSFetchedResultsController<Estado>!
    
    var dataSource: [Estado] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Lista de estados vazia!"
        label.textAlignment = .center
        label.textColor = .black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadEstados()
        
        
    }

    
    

    

}
// MARK: - NSFetchedResultsControllerDelegate
extension AjustesViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate
extension AjustesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let estado = dataSource[indexPath.row]
        showAlert(type: .edit, estado: estado)
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let estado = fetchedResultController.object(at: indexPath)
            if validaPermissao(estado: estado) {
                context.delete(estado)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func validaPermissao(estado: Estado) -> Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let predicate = NSPredicate(format: "estado = %@", estado)
        fetchRequest.predicate = predicate
        let entityDescription = NSEntityDescription.entity(forEntityName: "Compra", in: self.context)
        fetchRequest.entity = entityDescription
        do {
            let result = try self.context.fetch(fetchRequest)
            if result.count > 0 {
                showError(text: "Existem compra(s) vinculadas ao estado")
                return false
            }
        } catch {
            showError(text: "Existem compra(s) vinculadas ao estado")
            return false
        }
        
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "cotacao_dolar") == nil {
            UserDefaults.standard.set(3.19, forKey: "cotacao_dolar")
        }
        if UserDefaults.standard.string(forKey: "iof") == nil {
            UserDefaults.standard.set(3, forKey: "iof")
        }
        
        txtCotacao.text = UserDefaults.standard.string(forKey: "cotacao_dolar")
        txtIOF.text = UserDefaults.standard.string(forKey: "iof")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (txtCotacao.text != "") {
            UserDefaults.standard.set(txtCotacao.text!, forKey: "cotacao_dolar")
        }
        else {
            UserDefaults.standard.set(3.19, forKey: "cotacao_dolar")
        }
        
        if txtIOF.text != ""{
            UserDefaults.standard.set(txtIOF.text!, forKey: "iof")
        }
        else {
            UserDefaults.standard.set(3, forKey: "iof")
        }
    }
    
    func loadEstados() {
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    @IBAction func adicionar_estado(_ sender: Any) {
        showAlert(type: .add, estado: nil)
        
    }
    
    func showAlert(type: EstadoType, estado: Estado?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = estado?.nome {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            if let imposto = estado?.imposto {
                textField.text = "\(imposto)"
            }
            textField.keyboardType = .decimalPad
            textField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let estado = estado ?? Estado(context: self.context)
            estado.imposto = Float((alert.textFields?[1].text?.replacingOccurrences(of: ",", with: "."))!)!
            estado.nome = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadEstados()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.actions[0].isEnabled = (alert.textFields?.first?.text != "" && alert.textFields?[1].text != "")
        present(alert, animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[0].isEnabled = (alert.textFields?.first?.text != "" && alert.textFields?[1].text != "")
    }
}

// MARK: - UITableViewDelegate
extension AjustesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedResultController?.fetchedObjects?.count {
            tableView.backgroundView = (count == 0) ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
    }
    
    //Método que define a célula que será apresentada em cada linha
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "estadoCell", for: indexPath) as! AjustesTableViewCell
        let estado = fetchedResultController.object(at: indexPath)
        cell.lbCelEstado.text = estado.nome
        cell.lbCelImposto.text = "\(estado.imposto)"
        return cell
    }
    
    
    
    
}
