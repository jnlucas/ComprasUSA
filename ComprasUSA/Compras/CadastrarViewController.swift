//
//  CadastrarViewController.swift
//  ComprasUSA
//
//  Created by Usuário Convidado on 23/04/18.
//  Copyright © 2018 Philip. All rights reserved.
//

import UIKit
import CoreData


class CadastrarViewController: UIViewController {

    @IBOutlet weak var txtNomeProduto: UITextField!
    
    @IBOutlet weak var txtEstado: UITextField!
    @IBOutlet weak var txtValor: UITextField!
    @IBOutlet weak var swtCartao: UISwitch!
    
    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var btAddFoto: UIButton!
    @IBOutlet weak var btCadastrar: UIButton!
    
    
    var compra: Compra!
    var smallImage: UIImage!
    var pickerView: UIPickerView!
    
    var estadoSelecionado: Estado!
    var listEstados: [Estado]! = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if compra != nil {
            self.title = "Atualizar"
            txtNomeProduto.text = compra.nome
            swtCartao.isOn = compra.cartao
            txtValor.text = "\(compra.preco)"
            txtEstado.text = compra.estado?.nome
            estadoSelecionado = compra.estado
            if let image = compra.imagem as? UIImage {
                imgProduto.image = image
                btAddFoto.setTitle("", for: .normal)
            }
            btCadastrar.setTitle("Atualizar", for: .normal)
        }
        
        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        //O botão abaixo servirá para o usuário cancelar a escolha de gênero, chamando o método cancel
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //O botão done confirmará a escolha do usuário, chamando o método done.
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        
        //Aqui definimos que o pickerView será usado como entrada do extField
        txtEstado.inputView = pickerView
        
        //Definindo a toolbar como view de apoio do textField (view que fica acima do teclado)
        txtEstado.inputAccessoryView = toolbar
        
    }
    
    func loadEstado() {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Estado", in: self.context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.context.fetch(fetchRequest)
            for element  in result {
                let estado = element as! Estado
                listEstados.append(estado)
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    @objc func cancel() {
        txtEstado.resignFirstResponder()
    }
    
    //O método done irá atribuir ao textField a escolhe feita no pickerView
    @objc func done() {
        if (listEstados.count > 0) {
            estadoSelecionado = listEstados[pickerView.selectedRow(inComponent: 0)]
            txtEstado.text = listEstados[pickerView.selectedRow(inComponent: 0)].nome
        }
        cancel()
    }
    
    
    @IBAction func adicionarFoto(_ sender: Any) {
        
        //Criando o alerta que será apresentado ao usuário
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a foto?", preferredStyle: .actionSheet)
        
        //Verificamos se o device possui câmera. Se sim, adicionamos a devida UIAlertAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        //As UIAlertActions de Biblioteca de fotos e Álbum de fotos também são criadas e adicionadas
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
     func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func fechar(_ sender: Any) {
        dismiss(animated: true) 
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        
        
        if compra == nil {
            compra = Compra(context: context)
        }
        if !validaCampo(campo: txtNomeProduto, nomeCampo: "Nome do Produto") {
            return
        } else {
            compra.nome = txtNomeProduto.text!
        }
        
        if !validaCampo(campo: txtValor, nomeCampo: "Valor do Produto") {
            return
        } else {
            compra.preco = Float(txtValor.text!)!
        }
        compra.cartao = swtCartao.isOn
        
        if !validaCampo(campo: txtEstado, nomeCampo: "Estado da Compra") {
            return
        } else {
            compra.estado = estadoSelecionado
        }
        
        if smallImage != nil {
            compra.imagem = smallImage
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        
       dismiss(animated: true)
        
    }
    
    

}


extension CadastrarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        //Iremos usar o código abaixo para criar uma versão reduzida da imagem escolhida pelo usuário
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        //Atribuímos a versão reduzida da imagem à variável smallImage
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imgProduto.image = smallImage //Atribuindo a imagem à ivPoster
        
        //Aqui efetuamos o dismiss na UIImagePickerController, para retornar à tela anterior
        dismiss(animated: true, completion: nil)
    }
}

extension CadastrarViewController: UIPickerViewDelegate {
    override func viewWillAppear(_ animated: Bool) {
        loadEstado()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Retornando o texto recuperado do objeto dataSource, baseado na linha selecionada
        return listEstados[row].nome
    }
}

extension CadastrarViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    //Usaremos apenas 1 coluna (component) em nosso pickerView
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listEstados.count //O total de linhas será o total de itens em nosso dataSource
    }
}
