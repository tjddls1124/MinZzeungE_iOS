//
//  StoreMapController.swift
//  MinZzeungEE
//
//  Created by cadenzah on 15/06/2019.
//  Copyright © 2019 SungIn. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class StoreMapController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let defaultLocation = CLLocation(latitude: 37.561138, longitude: 127.039279)
    let defaultZoomLevel: Float = 16.0
    var locationManager = CLLocationManager()
    var _mapView: GMSMapView!
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var realSearchBar: UISearchBar!
    // searchBar is never used; just for a display
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func onClickBackButton(_ sender: Any) {
        self.resultView.isHidden = true
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // to hide keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // these two search bars have to be distinguished in delegate method
        searchBar.delegate = self
        searchBar.placeholder = "상호명을 입력해주세요"
        
        realSearchBar.delegate = self
        realSearchBar.placeholder = "상호명을 입력해주세요"
        
        resultTable.delegate = self
        resultTable.dataSource = self
        resultView.isHidden = true
        
        // to hide keyboard when other screen is touched
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withTarget: defaultLocation.coordinate, zoom: defaultZoomLevel)
        _mapView = GMSMapView(frame: self.mapView.frame, camera: camera)
        _mapView.frame = mapView.bounds
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 50
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        _mapView.settings.myLocationButton = true
        _mapView.isMyLocationEnabled = true
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        self.mapView.addSubview(_mapView)
        
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
                    store.map = self._mapView
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            _mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        _mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: defaultZoomLevel)
        mapView.addSubview(_mapView)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    // Search Bar relevant delegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.resultView.isHidden = false
        self.realSearchBar!.becomeFirstResponder()
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
