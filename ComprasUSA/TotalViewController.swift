//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    
    @IBOutlet weak var lbTotalDolar: UILabel!
    @IBOutlet weak var lbTotalReal: UILabel!
    
    var totalDolar: Double = 0
    var totalReal: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcularGastos()
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        calcularGastos()
    }
    
    func calcularGastos() {
        totalDolar = 0
        totalReal = 0
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Compra", in: self.context)
        
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.context.fetch(fetchRequest)
            for element  in result {
                let compra = element as! Compra
                var dolar = 1.0
                if UserDefaults.standard.string(forKey: "cotacao_dolar") != nil {
                    dolar = Double(UserDefaults.standard.string(forKey: "cotacao_dolar")!)!
                }
                var iof = 1.0
                if UserDefaults.standard.string(forKey: "iof") != nil {
                    iof = Double(UserDefaults.standard.string(forKey: "iof")!)!
                }
                let imposto = compra.estado?.imposto
                let valorImposto = (Double(compra.preco) * Double(imposto!))/100
                let valorCompra = Double(compra.preco) + Double(valorImposto)
                
                totalDolar = Double(totalDolar) + Double(valorCompra)
                let totalRealSemIOF = Double(totalDolar) * Double(dolar)
                let totalComIOF = (totalRealSemIOF * iof)/100
                totalReal += Double(totalRealSemIOF + totalComIOF)
                
            }
            
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        lbTotalDolar.text = String(format: "%.2f", totalDolar)
        lbTotalReal.text = String(format: "%.2f", totalReal)
        
    }
    

}
