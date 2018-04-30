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
    
    @IBOutlet weak var btAddEstado: UIButton!
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
        
        //PICKRVIEW
        pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
       
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolbar.items = [btCancel, btSpace, btDone]
        
        txtEstado.inputView = pickerView
        txtEstado.inputAccessoryView = toolbar
        
    }
    
    //MARK: - METHODS
    func loadEstado() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Estado", in: self.context)
        
        
        fetchRequest.entity = entityDescription
        do {
            let result = try self.context.fetch(fetchRequest)
            for element  in result {
                
                let estado = element as! Estado
                if !listEstados.contains(estado) {
                    listEstados.append(estado)
                }
               
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    @objc func cancel() {
        txtEstado.resignFirstResponder()
    }
    
    @objc func done() {
        if (listEstados.count > 0) {
            estadoSelecionado = listEstados[pickerView.selectedRow(inComponent: 0)]
            txtEstado.text = listEstados[pickerView.selectedRow(inComponent: 0)].nome
        }
        cancel()
    }
    
    @IBAction func adicionarFoto(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a foto?", preferredStyle: .actionSheet)
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
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
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func fechar(_ sender: Any) {
        dismiss(animated: true) 
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        
        if compra == nil {
            compra = Compra(context: context)
        }
        
        
        if !validaCampo(campo: txtNomeProduto, nomeCampo: "Nome do Produto")
            || !validaCampo(campo: txtEstado, nomeCampo: "Estado da compra")
            || !validaCampo(campo: txtValor, nomeCampo: "Valor do Produto") {
            return
        }else{
            compra.nome = txtNomeProduto.text!
            compra.preco = Double(txtValor.text!)!
            compra.cartao = swtCartao.isOn
            compra.estado = estadoSelecionado
            
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
   
}

//MARK: - EXTENSIONS

extension CadastrarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imgProduto.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension CadastrarViewController: UIPickerViewDelegate {
    override func viewWillAppear(_ animated: Bool) {
        loadEstado()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return listEstados[row].nome
    }
}

extension CadastrarViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listEstados.count
    }
}
