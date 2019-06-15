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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withTarget: defaultLocation.coordinate, zoom: defaultZoomLevel)
        self.mapView.camera = camera
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 50
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.settings.myLocationButton = true
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
