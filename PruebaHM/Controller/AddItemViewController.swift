//
//  AddItemViewController.swift
//  PruebaHM
//
//  Created by Omar Aldair Romero Pérez on 4/9/19.
//  Copyright © 2019 Omar Aldair Romero Pérez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lonTextField: UITextField!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }
    
    
    
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
        
        
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        
        
        if let title = titleTextField.text, let category = categoryTextField.text, let lat = latTextField.text, let lon = lonTextField.text, (title.count > 0 && category.count > 0 && lat.count > 0 && lon.count > 0){
            
            
            let reference = Storage.storage().reference().child("Items").child("image_\(UUID().uuidString).png")
            
            
            if let imageData = self.imageView.image?.pngData(){
                reference.putData(imageData, metadata: nil) { (metadata, error) in
                    
                    if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        
                        reference.downloadURL(completion: { (url, error) in
                            
                            if let imageURL = url?.absoluteString{
                                
                                
                                
                                if let lon = Double(lon), let lat = Double(lat){
                                    let data : [String:Any] = ["title":title, "category":category, "lon":lon, "lat":lat, "imageURL":imageURL]
                                    
                                    Database.database().reference().child("Items").childByAutoId().setValue(data) { (error, reference) in
                                        
                                        if error != nil{
                                            self.showAlert(title: "Error", message: error!.localizedDescription)
                                        }else{
                                            self.performSegue(withIdentifier: "newItemToMap", sender: nil)
                                        }
                                    }
                                }
                                
                                
                                
                            }
                        })
                    }
                }
            }
            
            
            
           
            
            
            
            
        }else{
            showAlert(title: "Campos vacíos", message: "Llena todos los campos")
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
  

}
