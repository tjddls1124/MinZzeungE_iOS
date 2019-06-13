//
//  MyTableViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 3. 28..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import SQLite3

var idList = Array<ID>()
var db : OpaquePointer? = nil

class MyTableViewController: UITableViewController{
    /**
     SQL CRUD FUNC
     */
    
    var index : Int? = -1
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
    


    //read
    func selectQuery() {
        let queryStatementString = "SELECT * FROM ID;"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(queryStatement, 0)
                let kind = String(cString: queryResultCol1!)
                let queryResultCol2 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol2!)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 2)
                let idFirstNum = String(cString: queryResultCol3!)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 3)
                let idLastNum = String(cString: queryResultCol4!)
                let queryResultCol5 = sqlite3_column_text(queryStatement, 4)
                let enrollDate = String(cString: queryResultCol5!)
                let queryResultCol6 = sqlite3_column_text(queryStatement, 5)
                let imgPath = String(cString: queryResultCol6!)
                let queryResultCol7 = sqlite3_column_text(queryStatement, 6)
                let valid = sqlite3_column_int(queryStatement, 7)
                print("Query Result:")
                print("\(name)")
                
                //image file load
                let curPath = getDocumentsDirectory()
                let fileURL = curPath.appendingPathComponent("\(imgPath).png")
                let data = try? Data(contentsOf: fileURL)
                let img = UIImage(data: data!)!
                var val : Bool = true
                if (valid == 0){
                    val = false
                }
                idList.append(
                    ID.init(kindKor: kind, name: name, idFirstNum: idFirstNum, idLastNum: idLastNum, enrollDate: enrollDate, image: img, valid: val)
                )
            }
        }
        sqlite3_finalize(queryStatement)
    }
    
    func deleteAll(){
        let deleteStatementStirng = "DELETE FROM ID;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    //delete
    func delete( pk : String ) {
        let deleteStatementStirng = "DELETE FROM ID WHERE imagePath = '\(pk)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    
    func dataLoad(){
        //Only When first strat,
        if(idList.count==0){
            db = openDatabase()
            createTable()
            //deleteAll()
            selectQuery()
        }
        
        
        /*
        //data load with Firebase
        let ref = Database.database().reference()
        var pk = ""
        var refID = ref.child("idData")
        var personID : ID?
        refID.observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as! [String : AnyObject?]
            print(value)
            for each in value{
                pk = each.value?["pk"] as! String
                personID = ID.init(idNum: pk)
            }
            
            //Load UIImage
            let imageRef = Storage.storage().reference().child("images/\(pk).jpg")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 15 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                } else {
                    // Data for "images/island.jpg" is returned
                    personID?.imageFilePath = UIImage(data: data!)!
                    idList.append(personID!)
                    self.tableView.reloadData()
                }
            }
            //pk = value?["pk"] as! String
        })*/
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        dataLoad()
        //print(idList)
        /*
        //data insert
        let personID  = ID.init(kind: .ID_Card, name: "하니",idFirstNum: "930215",idLastNum: "1xxxxxx",enrollDate: "",imageFilePath: UIImage(named: "idEx")!,isVaild: false)
        let person2ID = ID.init(kind: ID.idKind.DriverLicense , name: "Hong", idFirstNum: "930215", idLastNum: "1xxxxxx", enrollDate: "", imageFilePath: UIImage(named: "face")!, isVaild: false)
        let person3ID = ID.init(kind: ID.idKind.DriverLicense , name: "Hong", idFirstNum: "930215", idLastNum: "1xxxxxx", enrollDate: "", imageFilePath:  UIImage(named: "authentication")!, isVaild: false)
        idList.append(personID)
        idList.append(person2ID)
        idList.append(person3ID)
        */
        
        //long click event
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPressGesture)
        
    }
    
    //Swipe in order to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let id = idList[indexPath.row]
        let pk = "\(id.idFirstNum)-\(id.idLastNum)-\(id.kind.idKindString)"
        delete(pk: pk)
        idList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
    }
    
    //longclick event handle
    @objc func handleLongPress(sender : UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
                let alret : UIAlertController = UIAlertController(title: "신분증 수정", message: "해당 신분증을 수정하시겠습니까?", preferredStyle: .alert)
                self.present(alret, animated: true, completion: nil)
                index = self.tableView.indexPathForRow(at: sender.location(in: self.tableView))!.row
            let confirmAction : UIAlertAction = UIAlertAction(title: "수정", style: .default, handler: {
                    //modifying segue
                (confirmAction) in self.performSegue(withIdentifier: "ModifySegue", sender: sender)
                })
                let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                
                alret.addAction(cancleAction)
                alret.addAction(confirmAction)
        }
        
    }
    
    
    /**
     현재 directory url을 가져옴.
     */
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return idList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = idList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "idListCell") as! IDListCell
        cell.idImageView.image = row.imageFilePath
        

        
        var kindString = row.kind.idKind_korString
        kindString = "분류 : \(kindString)"
        
        cell.nameLabel.text = "이름 : \(row.name)"
        cell.kindLabel.text = "\(kindString)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailSeg"){
            let dest = segue.destination as! DetailViewController
            let item = idList[self.tableView.indexPathForSelectedRow!.row]
            dest.id = item
        }
        if(segue.identifier == "ModifySegue"){
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddToList_ViewController
            dest.modIndex = index!
        }
        else {return}
    }
    
    //unwind Code 추가, add 시에 Modal에서 데이터를 전달받기 위한 Code
    @IBAction func unwindToIDList(segue:UIStoryboardSegue){
        //print("unwind")
        //print(idList)
        self.tableView.reloadData()//refreshing View
        
        //TODO : Back 이후 Data 유지가 안됨 -> DB 사용할 것.
    }
    
    public func reload(id : ID){
        idList.append(id)
        self.tableView.reloadData()
    }
    
    @IBAction func AutenticateButton(_ sender: Any) {
        let fillInPassword =  UIAlertController(title: "비밀번호를 입력해주세요.", message: "", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            if(fillInPassword.textFields?[0].text == "database의 비밀번호"){
                //인증화면으로 전환
            }else{
                // present(fillInPassword, animated: true, completion: nil)
                fillInPassword.textFields?[0].placeholder = "비밀번호를 다시 입력주세요."
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
            present(fillInPassword, animated: true, completion: nil)
        }else{
            //인증화면으로 전환
        }
        
    }
}
