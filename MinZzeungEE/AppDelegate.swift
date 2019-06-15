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
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var currentPw : String?
    
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
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let blankView = storyboard.instantiateViewController(withIdentifier: "blankView")
        window?.rootViewController?.present(blankView, animated: true, completion: nil)
        print("Back")
    }
    
    //read
    func selectPwQuery() -> String?{
        let queryStatementString = "SELECT pw FROM Password;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(queryStatement, 0)
                let pw = String(cString: queryResultCol1!)
                print("select Query Result: \(pw)")
                
                sqlite3_finalize(queryStatement)
                return pw
            }
            else{
                print("select : no result")
                sqlite3_finalize(queryStatement)
                return nil
            }
        }
        else{
            print("select err")
        }
        sqlite3_finalize(queryStatement)
        return nil
    }
    
    func dbCreate(){
        db = openDatabase()
        createTable()
        createPwTable()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        dbCreate()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "idListTableView")

        let fillInPassword =  UIAlertController(title: "비밀번호를 입력해주세요.", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "exit", style: .default){ (cancel) in
            exit(0)
        }
        let ok = UIAlertAction(title: "enter", style: .default) { (ok) in
            if(fillInPassword.textFields?[0].text == self.currentPw){
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
            myTextField.isSecureTextEntry = true
        }
        
        var doSetPassword = false;
        //database에 비밀번호를 설정했을시
        //doSetPassword = true
        
        currentPw = selectPwQuery()
        //print("pw:" + String(currentPw!))
        if( currentPw != nil ){
            doSetPassword = true
        }
        
        if(doSetPassword){
            window?.rootViewController?.present(fillInPassword, animated: true, completion: nil)
        }else{
            window?.rootViewController?.present(nextView, animated: true, completion: nil)
        }
    }
    
    /**
     현재 directory url을 가져옴.
     */
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //sql DB connection & creation
    //db connect
    func openDatabase() -> OpaquePointer? {
        let dbPath = getDocumentsDirectory().appendingPathComponent("sqlDB").path
        var db: OpaquePointer? = nil
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
        return nil
    }
    
    //create
    func createPwTable() {
        let createTableString = "Create Table Password (pw char(30) primary key not null)"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Password table created.")
            } else {
                print("Password table could not be created.")
            }
        } else {
            print("Password TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //create table
    func createTable() {
        let createTableString = """
 CREATE TABLE ID(Kind CHAR(20) , Name CHAR(20), IdFirstNum CHAR(20) , IdLastNum CHAR(20), EnrollDate Char(30), imagePath Char(255) PRIMARY KEY NOT NULL , valid INTEGER);
 """
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    

}

