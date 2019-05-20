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
        let camera = GMSCameraPosition.camera(withLatitude: 37.5696, longitude: 126.98521819999996, zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // 사용자 위치정보 허락 모달
        self.locationManager.requestAlwaysAuthorization()
        mapView.isMyLocationEnabled = true
        
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
        //내위치로 이동
    }
    
}
