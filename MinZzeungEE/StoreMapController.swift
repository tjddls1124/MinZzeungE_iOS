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
import Cosmos

class StoreCell: UITableViewCell {
    
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeTitle: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeSnippet: UILabel!
    
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
    var id: String = ""
    var thumb: UIImage?
    var marker: GMSMarker?
    var address: String = ""
    var star: Double = 0.0
}

class StoreMapController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    let defaultLocation = CLLocation(latitude: 37.561138, longitude: 127.039279)
    let defaultZoomLevel: Float = 16.0
    var locationManager = CLLocationManager()
    var _mapView: GMSMapView!
    
    var refDatabase : DatabaseReference!
    var refStorage: StorageReference!
    var storesData: [Store] = [] // store data in this array
    var filteredData: [Store] = [] // filled when sth. is in the search text input

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var searchActive: Bool = false
    var imageReady: Bool = false
    var selectedMarker: GMSMarker?
    
    func toggleMapView() -> Void {
        // change view layout of button and search bar
        // open map view
        self.resultView.isHidden = true
        searchBar.frame.size.width = 414
        searchBar.frame.origin.x -= 44
        backButton.isHidden = true
    }
    
    func toggleSearchView() -> Void {
        // change view layout of button and search bar
        // open search view
        self.resultView.isHidden = false
        searchBar.frame.size.width = 370
        searchBar.frame.origin.x += 44
        backButton.isHidden = false
    }
    
    @IBAction func onClickBackButton(_ sender: Any) {
        toggleMapView()
        self.view.endEditing(true)
    }
    
    // Search Bar relevant delegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (self.storesData.count == 0 || !self.imageReady) {
            // data is not fetched yet! prevent unwrapping nil object
            self.resultView.isHidden = true
            let alertController = UIAlertController(title: "MinZzeungE", message: "가게 목록을 불러오는 중입니다. 잠시만 기다려주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else if (self.resultView.isHidden == true){
            self.resultTable.reloadData()
            self.searchActive = true
            toggleSearchView()
        } else {
            // do nothing
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StoreCell
        if (searchActive && filteredData.count != 0) {
            cell.storeTitle?.text = filteredData[indexPath.row].title
            cell.storeSnippet?.text = filteredData[indexPath.row].snippet
            cell.storeAddress?.text = filteredData[indexPath.row].address
            cell.storeImage?.image = filteredData[indexPath.row].thumb
        } else {
            cell.storeTitle?.text = storesData[indexPath.row].title
            cell.storeSnippet?.text = storesData[indexPath.row].snippet
            cell.storeAddress?.text = storesData[indexPath.row].address
            cell.storeImage?.image = storesData[indexPath.row].thumb
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when an item is selected
        // hide the result view, and return to the map view
        // map camera is set to the store's location
        let selectedStore = self.storesData[indexPath.row]
        let storeCoordinate = CLLocationCoordinate2D(latitude: selectedStore.latitude, longitude: selectedStore.longitude)
        _mapView.camera = GMSCameraPosition.camera(withTarget: storeCoordinate, zoom: defaultZoomLevel)
        mapView.addSubview(_mapView)
        tableView.deselectRow(at: indexPath, animated: false)
        
        // show storeInfoView
        storeInfoView.isHidden = false
        // SHOULD CHANGE Z-INDEX; _mapview will be plcaed over it
        storeInfoTitle!.text = storesData[indexPath.row].title
        storeInfoSnippet!.text = storesData[indexPath.row].snippet
        storeInfoAddress!.text = storesData[indexPath.row].address
        storeInfoImage!.image = storesData[indexPath.row].thumb
        mapView.bringSubviewToFront(storeInfoView)
        
        // change the previous store marker to default color
        if let marker = selectedMarker {
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
        }
        // and remember the marker
        selectedMarker = storesData[indexPath.row].marker
        selectedMarker!.icon = GMSMarker.markerImage(with: UIColor.blue)
        
        toggleMapView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    @IBOutlet weak var storeInfoView: UIView!
    
    @IBOutlet weak var storeInfoImage: UIImageView!
    @IBOutlet weak var storeInfoTitle: UILabel!
    @IBOutlet weak var storeInfoAddress: UILabel!
    @IBOutlet weak var storeInfoSnippet: UILabel!
    @IBOutlet weak var storeInfoStars: CosmosView!
    
    // ### MAIN METHOD FOR THIS VIEW CONTROLLER ###
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to hide keyboard when other screen is touched
        let tapGesture_Keyboard = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        // VERY IMPORTANT SINGLE CODE LINE TO PREVENT INTERFERENCE WITH TableViewCell touch
        tapGesture_Keyboard.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture_Keyboard)
        
        // delegate settings for search bars
        // these two search bars have to be distinguished in delegate method
        searchBar.delegate = self
        searchBar.placeholder = "상호명을 입력해주세요"
        
        // delegate settings for search result table
        resultTable.delegate = self
        resultTable.dataSource = self
        resultView.isHidden = true
        
        // map view settings to be displayed
        let camera = GMSCameraPosition.camera(withTarget: defaultLocation.coordinate, zoom: defaultZoomLevel)
        _mapView = GMSMapView(frame: self.mapView.frame, camera: camera)
        _mapView.frame = mapView.bounds
        
        // delegate settings for _mapview relevant functions
        _mapView.delegate = self
        
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
        
        // settings for star ratings
        storeInfoStars!.settings.fillMode = .precise
        storeInfoStars!.settings.updateOnTouch = false
        
        // data fetch from firebase DB
        refDatabase = Database.database().reference()
        
        refDatabase.child("stores").observe(.value, with: {(snapshot) in
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
                    
                    let address = storeData["address"] as? String
                    let star = storeData["star"] as? Double
                    let snippet = storeData["snippet"] as? String
                    // identifier to fetch image from firebase storage
                    let id = storeData["id"] as? String
                    
                    
                    self.storesData.append(Store(latitude: latitude, longitude: longitude, title: title, snippet: snippet!, id: id!, thumb: nil,  marker: nil, address: address!, star: star! ))
                }
            }
            
            // fetch images for each stores (small-size-thumbnails)
            // ### THUMBNAIL FILE NAME and STORE ID HAS TO BE IDENTICAL ###
            self.refStorage = Storage.storage().reference().child("stores/thumbnails")
            for i in 0 ..< self.storesData.count {
                // fetch image
                let imageId = self.storesData[i].id
                let imageRef = self.refStorage.child("\(imageId).png")
                imageRef.getData(maxSize: 1 * 1024 * 256) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        // generate marker
                        let marker = GMSMarker()
                        
                        // store thumbnail image for each store
                        self.storesData[i].thumb = UIImage(data: data!)
                        marker.position = CLLocationCoordinate2D(latitude: self.storesData[i].latitude, longitude: self.storesData[i].longitude)
                        marker.appearAnimation = GMSMarkerAnimation.pop
                        
                        marker.map = self._mapView
                        
                        // used as an identifier to fetch images from firebase storage
                        marker.userData = self.storesData[i].id
                        
                        // save the reference for its GMSMarker
                        self.storesData[i].marker = marker
                    }
                    self.resultTable.reloadData()
                    if i == self.storesData.count - 1 {
                        self.imageReady = true
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // when the map except for marker is touched - hide info view
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        // change the previous marker to default color
        if let marker = selectedMarker {
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
        }
        selectedMarker = nil
        
        // hide info view
        storeInfoView.isHidden = true
    }
    
    // when the marker is touched - show info view relevent to that marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        // change the previous marker to default color
        if let marker = selectedMarker {
            marker.icon = GMSMarker.markerImage(with: UIColor.red)
        }
        // and remember the marker
        selectedMarker = marker
        
        // camera move to the marker
        _mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: defaultZoomLevel)
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        
        // show storeInfoView
        storeInfoView.isHidden = false
        // SHOULD CHANGE Z-INDEX; _mapview will be plcaed over it
        let storeData = storesData.filter({(value: Store) -> Bool in
            return value.id == (marker.userData as! String)
        })[0]
        
        storeInfoTitle!.text = storeData.title
        storeInfoSnippet!.text = storeData.snippet
        storeInfoAddress!.text = storeData.address
        storeInfoImage!.image = storeData.thumb
        
        storeInfoStars!.rating = storeData.star
        print(storeInfoStars!.rating)
        storeInfoStars!.text = "(\(Int.random(in: 0..<50)))"
        
        self.mapView.bringSubviewToFront(storeInfoView)
        
        return true
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "STORE_DETAIL"){
            let dest = segue.destination as! StoreDetailViewController
            
            dest.storeTitle = storeInfoTitle!.text
            dest.storeId = selectedMarker!.userData as? String
        }
        else {
            return
        }
    }
    
}
