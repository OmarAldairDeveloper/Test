//
//  AddItemForPointViewController.swift
//  PruebaHM
//
//  Created by Omar Aldair Romero Pérez on 4/9/19.
//  Copyright © 2019 Omar Aldair Romero Pérez. All rights reserved.
//

import UIKit
import MapKit
import FirebaseStorage
import FirebaseDatabase

class AddItemForPointViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var map: MKMapView!
    
    
    let imagePicker = UIImagePickerController()
    var lat: String?
    var lon: String?
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(getLatAndLong(gesture:)))
        map.addGestureRecognizer(gesture)
        
    }
    
    
    @objc func getLatAndLong(gesture: UILongPressGestureRecognizer){
        
        if gesture.state == .began{
            let touchLocation = gesture.location(in: map)
            let location = map.convert(touchLocation, toCoordinateFrom: map)
            
            
            let numberFormatter = NumberFormatter()
            numberFormatter.minimumIntegerDigits = 2
            numberFormatter.maximumFractionDigits = 6
            
            lat = numberFormatter.string(for: Double(location.latitude))
            lon = numberFormatter.string(for: Double(location.longitude))
            
            
            let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            
            
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "(\(lat!),\(lon!)"
            map.addAnnotation(annotation)
            
        }
    }
    

    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "newItemMapToMap", sender: nil)
    }
    
    
    @IBAction func saveItemAction(_ sender: UIButton) {
        
        if let title = titleTextField.text, let category = categoryTextField.text, (title.count > 0 && category.count > 0){
            
            
            let reference = Storage.storage().reference().child("ItemsForMaps").child("image_\(UUID().uuidString).png")
            
            
            if let imageData = self.imageView.image?.pngData(){
                reference.putData(imageData, metadata: nil) { (metadata, error) in
                    
                    if error != nil{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }else{
                        
                        reference.downloadURL(completion: { (url, error) in
                            
                            if let imageURL = url?.absoluteString{
                            
                                
                                if let latitude = self.lat, let longitude = self.lon{
                                    
                                    
                                    
                                    if let lat = Double(latitude), let lon = Double(longitude){
                                        
                                        
                                        
                                        
                                        let reference = Database.database().reference().child("Items").childByAutoId()
                                        
                                        let key = reference.key
                                        
                                        let data : [String:Any] = ["title":title, "category":category, "lon":lon, "lat":lat, "imageURL":imageURL, "key":key]
                                        
                                        reference.setValue(data) { (error, reference) in
                                            
                                            if error != nil{
                                                self.showAlert(title: "Error", message: error!.localizedDescription)
                                            }else{
                                                self.performSegue(withIdentifier: "newItemMapToMap", sender: nil)
                                            }
                                        }
                                    }
                                    
                                }

                                
                                
                                
                                
                            }
                        })
                    }
                }
            }
            
        }else{
            showAlert(title: "Campos vacíos", message: "Llene todos los campos")
        }
        
    }
    
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            self.imageView.image = image
            self.imageView.contentMode = .scaleAspectFit
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
