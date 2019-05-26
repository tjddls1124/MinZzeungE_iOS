//
//  MapsViewController.swift
//
//
//  Created by admin on 16/05/2019.
//

/*
 * Data used in this map is stored in Firebase DB (Account of "MinZzeungE")
 * The database is all based on JSON format
 * So CRUD is not very difficult: Just make a JSON file, upload it, and that's it!
 * Also Firebase DB supports URI scheme;
 * You can easily limit the scope of what you are trying to access or modify by specifying the URI
 * for example: only accessing "stores" object in entire DB
 => Database.database().reference().child("stores")
 By limiting like this, you don't have to touch any other data in JSON DB
 */

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseDatabase

class MapsViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var zoomLevel: Float = 16.0
    
    let defaultLocation = CLLocation(latitude: 37.561138, longitude: 127.039279)
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude, longitude: defaultLocation.coordinate.longitude, zoom: zoomLevel)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.camera = camera
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 50
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        self.mapView.settings.myLocationButton = true
        self.mapView.isMyLocationEnabled = true
        
        self.view = mapView
        
        ref = Database.database().reference()
        
        ref.child("stores").observe(.value, with: {(snapshot) in
            let stores = snapshot.value as? [String: AnyObject] ?? [:]
            
            /*
             * Request data of stores supports this application from Firebase DB
             * bring them together, and use it in to generate marker
             * CAUTIONS: the `snapshot` is volatile data; you can only use the data within this closure
             */
            
            // Generate marker for each store
            for store in stores {
                let title = store.key
                if let storeData = stores[store.key] as? [String: AnyObject],
                    let location = storeData["gps"] as? [String: AnyObject] {
                    // Preparing data to display in the marker
                    // Datatype for data in Firebase DB is different from native datatype in Swift,
                    // So it has to be converted to adequate types before using it
                    let latitude = Double(truncating: location["latitude"]! as! NSNumber)
                    let longitude = Double(truncating: location["longitude"]! as! NSNumber)
                    
                    let snippet = storeData["snippet"] as? String
                    
                    let store = GMSMarker()
                    store.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    store.title = title
                    store.snippet = snippet
                    store.map = self.mapView
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    override func loadView() {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: zoomLevel)
        self.view = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}
