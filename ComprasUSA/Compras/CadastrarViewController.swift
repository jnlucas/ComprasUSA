//
//  CadastrarViewController.swift
//  ComprasUSA
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit

class CadastrarViewController: UIViewController {

    @IBOutlet weak var txtNomeProduto: UITextField!
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var swtCartao: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fechar(_ sender: Any) {
        dismiss(animated: true) 
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
