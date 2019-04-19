//
//  MyTableViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 3. 28..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit
import Foundation

class MyTableViewController: UITableViewController{
    var idList = Array<ID>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //data insert
        let personID  = ID.init(kind: idKind.ID_Card, name: "하니",idFirstNum: "930215",idLastNum: "1xxxxxx",enrollDate: "",imageFilePath: "idEx",isVaild: false)
        let person2ID = ID.init(kind: idKind.DriverLicense, name: "Hong", idFirstNum: "930215", idLastNum: "1xxxxxx", enrollDate: "", imageFilePath: "lcguide02", isVaild: false)
        idList.append(personID)
        idList.append(person2ID)
        
        
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
        cell.idImageView.image = UIImage(named:row.imageFilePath)
        var kindString : String
        if row.kind == idKind.DriverLicense {
            kindString = "분류 : 운전면허증"
        }
        else {
            kindString = "분류 : 주민등록증"
        }
        cell.nameLabel.text = "이름 : \(row.name)"
        cell.kindLabel.text = "\(kindString)"
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailSeg"){
            let dest = segue.destination as! DetailViewController
            let item = self.idList[self.tableView.indexPathForSelectedRow!.row]
            dest.id = item
        }
        else {return}
    }
}
