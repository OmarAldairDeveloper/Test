//
//  ItemViewController.swift
//  PruebaHM
//
//  Created by Omar Aldair Romero Pérez on 4/9/19.
//  Copyright © 2019 Omar Aldair Romero Pérez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ItemViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var items = [Item]()
    
   

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCV(gesture:)))
        collectionView.addGestureRecognizer(tapGesture)
        
        // Consumir
        Database.database().reference().child("Items").observe(.childAdded) { (snapshot) in
            
            if let snapValue = snapshot.value as? [String:Any]{
                
                if let title = snapValue["title"] as? String, let lat = snapValue["lat"] as? Double, let lon = snapValue["lon"] as? Double, let imageURL = snapValue["imageURL"] as? String, let category = snapValue["category"] as? String, let key = snapValue["key"] as? String{
                    
                    
                    
                    let itemObject = Item(title: title, category: category, lat: lat, lon: lon, imageURL: imageURL, key: key)
                    self.items.append(itemObject)
                    self.collectionView.reloadData()
                }
            }
            
        }
        
        
       
        
        /*Database.database().reference().child("Items").observe(.childRemoved) { (snapshot) in
         
        }*/
        

        
    }
    
    
    @objc func longPressCV(gesture: UILongPressGestureRecognizer){
        
        if gesture.state == .began{
            
            let touchPoint = gesture.location(in: self.view)
            
            if let indexPath = collectionView.indexPathForItem(at: touchPoint){
                
                let item = self.items[indexPath.row]
                
                
                let alert = UIAlertController(title: "Eliminar", message: "", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Si", style: .destructive, handler: { (_) in
                    Database.database().reference().child("Items").child(item.key).removeValue(completionBlock: { (error, reference) in
                        
                        if error != nil{
                            
                        }else{
                        
                            self.collectionView.reloadData()
                            self.performSegue(withIdentifier: "returnMapsSegue", sender: nil)
                        
                        }
                    })
                }))
                
                alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
                
                
                present(alert, animated: true)
            }
                
            
            
            
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCell", for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.latLabel.text = "Lat: \(item.lat)"
        cell.lonLabel.text = "Lon: \(item.lon)"
        cell.categoryLabel.text = item.category
        cell.layer.backgroundColor = UIColor.lightGray.cgColor
        
        if let imageURL = URL(string: item.imageURL){
            cell.imageView.kf.setImage(with: imageURL)
        }
        
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let item = items[indexPath.row]
        let alert = UIAlertController(title: "Editar Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (txtField) in
            txtField.placeholder = "Titulo"
            txtField.text = item.title
            
        }
        
        
        alert.addTextField { (txtField) in
            txtField.placeholder = "Categoria"
            txtField.text = item.category
            
        }
        
        
        alert.addTextField { (txtField) in
            txtField.placeholder = "Latitud"
            txtField.text = String(item.lat)
            
        }
        
        
        
        alert.addTextField { (txtField) in
            txtField.placeholder = "Longitud"
            txtField.text = String(item.lon)
            
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Editar", style: .default, handler: { (_) in
            
            if let newTitle = alert.textFields?.first?.text, let newCategory = alert.textFields?[1].text, let newLat = alert.textFields?[2].text, let newLon = alert.textFields?[3].text{
                
                if let finalLat = Double(newLat), let finalLon = Double(newLon){
                    let newData :[String:Any] = ["title": newTitle, "category":newCategory, "lat":finalLat, "lon":finalLon]
                    
                    Database.database().reference().child("Items").child(item.key).updateChildValues(newData, withCompletionBlock: { (error, reference) in
                        
                        if error != nil{
                            
                        }else{
                            self.collectionView.reloadData()
                            self.performSegue(withIdentifier: "returnMapsSegue", sender: nil)
                        }
                    })
                    
                }
                
            }
            
            
            
        }))
        
        present(alert, animated: true)
        
        
        
        
        
        
        
        
        
    }
    
    

   

    @IBAction func returnMapsAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "returnMapsSegue", sender: nil)
    }
}
