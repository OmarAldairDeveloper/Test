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
import FirebaseAuth

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var items = [Item]()
    
    
   let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var otherLocation = CLLocationCoordinate2D()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        

        
        // Consumir
        Database.database().reference().child("Items").observe(.childAdded) { (snapshot) in
            
            if let snapValue = snapshot.value as? [String:Any]{
                
                if let title = snapValue["title"] as? String, let lat = snapValue["lat"] as? Double, let lon = snapValue["lon"] as? Double, let imageURL = snapValue["imageURL"] as? String, let category = snapValue ["category"] as? String, let key = snapValue["key"] as? String{
                    
                    
                    
                    let itemObject = Item(title: title, category: category, lat: lat, lon: lon, imageURL: imageURL, key: key)
                    self.items.append(itemObject)
                    self.collectionView.reloadData()
                }
            }
            
        }
        
    }
    
    
    

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        try? Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func goAction(_ sender: UIButton) {
        
        
        let clotherLocation = CLLocation(latitude: otherLocation.latitude, longitude: otherLocation.longitude)
        
        
        CLGeocoder().reverseGeocodeLocation(clotherLocation) { (placemarks, error) in
            
            if let placemarks = placemarks{
                if placemarks.count > 0 {
                    let placeMark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = "Otro item"
                    
                    
                    let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
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
        
        locationManager.stopUpdatingLocation()
        let item = items[indexPath.row]
        
        showInMap(item: item)
        
        
        
    }
    
    
    func showInMap(item: Item){
        
        otherLocation = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
        
        let region = MKCoordinateRegion(center: otherLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region, animated: true)
        
        map.removeAnnotations(map.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = otherLocation
        annotation.title = "Localización"
        map.addAnnotation(annotation)
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coord = manager.location?.coordinate{
            
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            
            self.userLocation = center
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            map.setRegion(region, animated: true)
            
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Tu localización"
            map.addAnnotation(annotation)
            
        }
    }
}
