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

class StoreCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// data model for store data
struct Store {
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var title: String = ""
    var snippet: String = ""
}

class StoreMapController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let defaultLocation = CLLocation(latitude: 37.561138, longitude: 127.039279)
    let defaultZoomLevel: Float = 16.0
    var locationManager = CLLocationManager()
    var _mapView: GMSMapView!
    
    var ref: DatabaseReference!
    var storesData: [Store] = [] // store data in this array
    var filteredData: [Store] = [] // filled when sth. is in the search text input
    
    @IBOutlet weak var realSearchBar: UISearchBar!
    // searchBar is never used; just for a display
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var searchActive: Bool = false
    
    @IBAction func onClickBackButton(_ sender: Any) {
        self.resultView.isHidden = true
        self.view.endEditing(true)
    }
    
    // Search Bar relevant delegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
        self.resultView.isHidden = false
        self.realSearchBar!.becomeFirstResponder()
        print(self.storesData)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = storesData.filter({ (store) -> Bool in
            let temp: NSString = store.title as NSString
            let range = temp.localizedStandardRange(of: searchText)
            return range.location != NSNotFound
        })
        
        if (filteredData.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        self.resultTable.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filteredData.count
        } else {
            return storesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        if (searchActive) {
            cell.textLabel?.text = filteredData[indexPath.row].title
        } else {
            cell.textLabel?.text = storesData[indexPath.row].title
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to hide keyboard when other screen is touched
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

        
        // delegate settings for search bars
        // these two search bars have to be distinguished in delegate method
        searchBar.delegate = self
        searchBar.placeholder = "상호명을 입력해주세요"
        realSearchBar.delegate = self
        realSearchBar.placeholder = "상호명을 입력해주세요"
        
        // delegate settings for search result table
        resultTable.delegate = self
        resultTable.dataSource = self
        resultView.isHidden = true
        
        // map view settings to be displayed
        let camera = GMSCameraPosition.camera(withTarget: defaultLocation.coordinate, zoom: defaultZoomLevel)
        _mapView = GMSMapView(frame: self.mapView.frame, camera: camera)
        _mapView.frame = mapView.bounds
        
        // settings for location manager (tracking)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 50
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // my location button
        _mapView.settings.myLocationButton = true
        _mapView.isMyLocationEnabled = true
        
        self.mapView.addSubview(_mapView)
        
        // data fetch from firebase DB
        ref = Database.database().reference()
        
        ref.child("stores").observe(.value, with: {(snapshot) in
            let stores = snapshot.value as? [String: AnyObject] ?? [:]
            
            /*
             * Request data of stores supports this application from Firebase DB
             * bring them together, and use it in to generate marker
             * data retrieved here will be stored in `storesData` variable
             * CAUTION for asynchronous action
             */
            
            // fetch data
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
                    
                    self.storesData.append(Store(latitude: latitude, longitude: longitude, title: title, snippet: snippet!))
                }
            }
            
            // generate markers
            for store in self.storesData {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
                marker.title = store.title
                marker.snippet = store.snippet
                marker.map = self._mapView
            }
            self.resultTable.reloadData()
            
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
    
}
