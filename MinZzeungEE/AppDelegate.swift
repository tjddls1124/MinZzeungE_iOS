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
        
        //Thread.sleep(forTimeInterval: 2.0)
        // init Firebase connection
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // window?.rootViewController?.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "idListTableView")

        let fillInPassword =  UIAlertController(title: "비밀번호를 입력해주세요.", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "exit", style: .default){ (cancel) in
            exit(0)
        }
        let ok = UIAlertAction(title: "enter", style: .default) { (ok) in
            if(fillInPassword.textFields?[0].text == "123"){
                //코드로 스토리보드전환
                //self.window?.rootViewController?.show(nextView, sender: nil)
                self.window?.rootViewController?.present(nextView, animated: true, completion: nil)
                
            }else{
                let attributedString = NSAttributedString(string: "비밀번호가 틀렸습니다.", attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                    NSAttributedString.Key.foregroundColor : UIColor.red
                    ])
                fillInPassword.setValue(attributedString, forKey: "attributedTitle")
                fillInPassword.textFields?[0].text = ""
                fillInPassword.textFields?[0].placeholder = "password"
                self.window?.rootViewController?.present(fillInPassword, animated: true, completion: nil)
            }
        }
        
        fillInPassword.addAction(cancel)
        fillInPassword.addAction(ok)
        fillInPassword.addTextField { (myTextField) in
            myTextField.placeholder = "password"
        }
        
        var doSetPassword = false;
        //database에 비밀번호를 설정했을시
        doSetPassword = true
        
        if(doSetPassword){
            window?.rootViewController?.present(fillInPassword, animated: true, completion: nil)
        }else{
            window?.rootViewController?.present(nextView, animated: true, completion: nil)
        }
    }
}

