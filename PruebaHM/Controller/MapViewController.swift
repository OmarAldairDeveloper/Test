//
//  MapViewController.swift
//  PruebaHM
//
//  Created by Omar Aldair Romero Pérez on 4/9/19.
//  Copyright © 2019 Omar Aldair Romero Pérez. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import FirebaseDatabase

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var items = [Item]()
    
    
   
    
    
    
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
    

   
}


extension MapViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.latLabel.text = "Lat: \(item.lat)"
        cell.lonLabel.text = "Lon: \(item.lon)"
        cell.layer.backgroundColor = UIColor.lightGray.cgColor
        
        if let imageURL = URL(string: item.imageURL){
            cell.imageView.kf.setImage(with: imageURL)
        }
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let item = items[indexPath.row]
        
        showInMap(item: item)
        
        
        
    }
    
    
    func showInMap(item: Item){
        let location = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: true)
        
        map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Localización"
        map.addAnnotation(annotation)
    }
}
