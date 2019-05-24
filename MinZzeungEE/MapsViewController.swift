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
import FirebaseDatabase

class MapsViewController: UIViewController {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        
        // Ask permission to use user's location info
        // Popup the modal
        self.locationManager.requestAlwaysAuthorization()
        
        // Get Database reference for Firebase
        ref = Database.database().reference()
        
        // stores 전체를 가져온 뒤,
        // for문 돌려서 배열에 넣기
        // 배열을 가지고 반복적으로 view 만들어서 화면에 마커 적용
        var stores: [String: AnyObject]!
        var mapView: GMSMapView!
        
        self.locationManager.startUpdatingLocation()
        
        if let latitude = self.locationManager.location?.coordinate.latitude,
            let longitude = self.locationManager.location?.coordinate.longitude {
            
            // reference for user's current real-time location
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
            let _mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view = _mapView
            
            // Enable map to use user's location
            _mapView.isMyLocationEnabled = true
            
            // Create a button which shows user's current location by marker in the map
            _mapView.settings.myLocationButton = true
            // Show compass in the map
            _mapView.settings.compassButton = true
            
            mapView = _mapView
        }
        
        ref.child("stores").observe(.value, with: {(snapshot) in
            stores = snapshot.value as? [String: AnyObject] ?? [:]
            
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
                    store.map = mapView
                    }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //
        
        
        // Enable tracking the user's location in real-time
        
        
        
    }
    
}
