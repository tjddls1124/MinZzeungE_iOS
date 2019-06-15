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

class StoreMapController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let defaultLocation = CLLocation(latitude: 37.561138, longitude: 127.039279)
    let defaultZoomLevel: Float = 16.0
    var locationManager = CLLocationManager()
    var _mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.mapView.addSubview(_mapView)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            _mapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        _mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: defaultZoomLevel)
//        self.view = self.mapView
        mapView.addSubview(_mapView)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
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
