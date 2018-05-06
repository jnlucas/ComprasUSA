//
//  UIViewController+CoreData.swift
//  ComprasUSA
//
//  Created by joao neves on 28/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//


import CoreData
import UIKit

extension UIViewController {
    
    //MARK: - ATRIBUTES
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: - METHODS
    func showError(text: String) {
        showError(text: text, campo: nil)
    }
    
    func showError(text: String, campo: UITextField?) {
        let title = "Atenção"
        let alert = UIAlertController(title: "\(title)", message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            if campo != nil {
                campo?.becomeFirstResponder()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func validaCampo(campo: UITextField, nomeCampo: String) -> Bool {
        if (campo.text?.isEmpty)! || (campo.text?.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty)! {
            showError(text: "Campo \(nomeCampo) não pode ser vazio", campo: campo)
            
            return false
        }
        return true
    }
    
    func validaTipo(campo: UITextField, nomeCampo: String, tipo: String) -> Bool {
        if (!validaCampo(campo:campo,nomeCampo:nomeCampo))
        {
            return false
        }
        
        if tipo == "number"{
            guard let valor = campo.text else {return false}
            
            if !valor.isnumberordouble{
                showError(text: "Campo \(nomeCampo) esta com o tipo errado", campo: campo)
                return false
            }
            
        }
        return true
        
    }
    
   
}
extension String  {
    var isnumberordouble: Bool { return Int(self) != nil || Double(self) != nil }
}
