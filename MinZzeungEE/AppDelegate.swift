//
//  AppDelegate.swift
//  TextExtractor
//
//  Created by Mobdev125 on 3/18/19.
//  Copyright © 2019 Mobdev125. All rights reserved.
//
import UIKit
import Firebase
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // init Google Maps API
        GMSServices.provideAPIKey("AIzaSyA_xbj87-urox0E6yQHBzBtEz3D4smfSgk")
        GMSPlacesClient.provideAPIKey("AIzaSyA_xbj87-urox0E6yQHBzBtEz3D4smfSgk")
        
        // init Firebase connection
        FirebaseApp.configure()
        
        return true
    }
}

