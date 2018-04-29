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
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
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
}

