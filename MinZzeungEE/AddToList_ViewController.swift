//
//  AddToList_ViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 4. 25..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit

class AddToList_ViewController: UITableViewController {
    
    @IBOutlet weak var sc_idKind: UIView!
    @IBOutlet weak var textField_idFirsttNum: UITextField!
    @IBOutlet weak var textField_name: UITextField!
    
    @IBOutlet weak var textField_idLastNum: UITextField!
    
    @IBOutlet weak var imageView_IDCard: UIImageView!
    
    @IBAction func idKind_change(_ sender: Any) {
        //TODO : pick를 변경하면 view 종류에 맞는 view를 바꿔 띄워준다.
    }
    @IBAction func addCardImage(_ sender:Any){
        //TODO : imageView Click event 달기 -> use UITabGestureRecognizer
    }
    
    @IBAction func modalDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddComplete(_ sender: Any) {
        //TODO : if 문으로 Obj들이 올바르게 들어오는지 체크할 것.
        //TODO : 올바르게 들어왓다면 List에 추가하고 modal을 dismiss
        //TODO : 아니라면 예외처리 후 다시 입력하라는 메시지 띄우기
        self.dismiss(animated: true, completion: {print("ID_LIST에 신분증이 추가되었습니다.")}) //completion은 void 를 리턴하는 closure
        //TODO : console 출력 -> message 띄우기로 바꿀 것
        //TODO : unwind seg 를 이용하는 방식으로 변경. Don't use this func.
    }
    
    func makeNewID() -> ID?{/*
        guard let newID = ID.init() else{
            return nil
        }
        //TODO : make New ID by using self's field, fill into init()
        return newID
        */
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    

/
*/
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addDone"{
            //adList가 완벽히 add 되어 seg가 올바르게 전송되었다면
            //self.IDList에 추가
            guard let newID = makeNewID(), let idListController = segue.destination as? MyTableViewController else{
                return
            }
            print("add Done!")
            idListController.idList.append(newID)
        }
    }
    
}
