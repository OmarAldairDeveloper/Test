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
        
        // Consumir
        Database.database().reference().child("Items").observe(.childAdded) { (snapshot) in
            
            if let snapValue = snapshot.value as? [String:Any]{
                
                if let title = snapValue["title"] as? String, let lat = snapValue["lat"] as? Double, let lon = snapValue["lon"] as? Double, let imageURL = snapValue["imageURL"] as? String, let category = snapValue ["category"] as? String{
                    
                    
                    
                    let itemObject = Item(title: title, category: category, lat: lat, lon: lon, imageURL: imageURL)
                    self.items.append(itemObject)
                    self.collectionView.reloadData()
                }
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCell", for: indexPath)
        
        
        return cell
    }
    
    

   

    @IBAction func returnMapsAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "returnMapsSegue", sender: nil)
    }
}
