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
var idList = Array<ID>()

class MyTableViewController: UITableViewController{
    
    func dataLoad(){
        
        
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
        print(idList)
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
        idList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
    }
    
    //longclick event handle
    @objc func handleLongPress(sender : UILongPressGestureRecognizer){
            let alret : UIAlertController = UIAlertController(title: "신분증 수정", message: "해당 신분증을 수정하시겠습니까?", preferredStyle: .alert)
            self.present(alret, animated: true, completion: nil)
        let confirmAction : UIAlertAction = UIAlertAction(title: "수정", style: .default, handler: {
            result in // TODO : modifying
        })
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alret.addAction(cancleAction)
        alret.addAction(confirmAction)
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
    
}
