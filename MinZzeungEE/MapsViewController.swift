//
//  MapsViewController.swift
//
//
//  Created by admin on 16/05/2019.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        
        // Ask permission to use user's location info
        // Popup the modal
        self.locationManager.requestAlwaysAuthorization()
        
        // Enable tracking the user's location in real-time
        self.locationManager.startUpdatingLocation()
        
        if let latitude = self.locationManager.location?.coordinate.latitude,
            let longitude = self.locationManager.location?.coordinate.longitude {
            
            // reference for user's current real-time location
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            self.view = mapView
            
            // Enable map to use user's location
            mapView.isMyLocationEnabled = true
            
            // Create a button which shows user's current location by marker in the map
            mapView.settings.myLocationButton = true
            // Show compass in the map
            mapView.settings.compassButton = true
            
            
            // Creates a marker in the center of the map.
            let restraunt1 = GMSMarker()
            restraunt1.position = CLLocationCoordinate2D(latitude: 37.5696, longitude: 126.98521819999996)
            restraunt1.title = "경성주막"
            restraunt1.snippet = "왕십리"
            restraunt1.map = mapView
            
            let restraunt2 = GMSMarker()
            restraunt2.position = CLLocationCoordinate2D(latitude: 37.5690, longitude: 126.98521819999996)
            restraunt2.title = "백번"
            restraunt2.snippet = "왕십리"
            restraunt2.map = mapView
            
            //마커추가하는법
            // 지도 상에서 마커를 추가할 수 있도록
            
            //내위치로 이동
            
        }
        
        
    }
    
}
