//
//  LockViewController.swift
//  MinZzeungEE
//
//  Created by admin on 28/05/2019.
//  Copyright © 2019 SungIn. All rights reserved.
//

import UIKit
import SQLite3

class LockViewController: UIViewController{

    var currentPw : String? = nil
    var modifyMode : Bool = false

    @IBOutlet weak var passwordMessage: UITextView!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatedPassword: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonBox: UITextField!
    
    func showToast(message : String, second : Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.lightGray
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + second) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func deleteCurPw(_ sender: Any) {
        let alert = UIAlertController(title:"비밀번호 삭제", message: "비밀번호를 삭제하시려면\n현재 설정된 비밀번호를 입력하세요.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            let inputPw = alert.textFields![0].text
            if(inputPw == self.currentPw){//올바른 입력
                self.deleteAll()
                self.showToast(message: "비밀번호가 삭제되었습니다", second: 2.0)
                self.performSegue(withIdentifier: "deletePwComplete", sender: nil)
            }
            else{//아니라면 다시 입력 확인
                self.showToast(message: "비밀번호가 올바르지 않습니다.\n다시 확인해주세요", second: 2.0)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "비밀번호를 입력하세요"
            textField.textContentType = UITextContentType.password
            textField.isSecureTextEntry = true
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        //check existing Password
        let pw = selectPwQuery()
        if( pw == nil){
            self.currentPassword.isHidden = true
            doneButton.setTitle("확인", for: .normal)
            currentPassword.isHidden = true
            newPassword.placeholder = "password"
            repeatedPassword.placeholder = "one more"
            passwordMessage.text = ""
            self.deleteButton.isHidden = true
            deleteButtonBox.isHidden = true
            
        }
        else{
            self.deleteButton.isHidden = false
            self.deleteButtonBox.isHidden = false
            modifyMode = true
            currentPw = pw
            doneButton.setTitle("변경", for: .normal)
            currentPassword.isHidden = false
            newPassword.text = ""
            repeatedPassword.text = ""
            currentPassword.text = ""
            passwordMessage.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordMessage.delegate = self as? UITextViewDelegate
        newPassword.delegate = self as? UITextFieldDelegate
        repeatedPassword.delegate = self as? UITextFieldDelegate
        currentPassword.delegate = self as? UITextFieldDelegate
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
       
        
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        //deleteAll()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ sender:Notification){
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender:Notification){
        self.view.frame.origin.y = 0
    }
    
    @objc func endEditing(){
        passwordMessage.resignFirstResponder()
        newPassword.resignFirstResponder()
        repeatedPassword.resignFirstResponder()
        currentPassword.resignFirstResponder()
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
    
    //delete all
    func deleteAll(){
        let deleteStatementStirng = "DELETE FROM Password;"
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
    
    
    //update
    func update(curPw : String, pw : String) {
        let updateStatementString = "UPDATE Password SET pw = '\(pw)' WHERE pw = '\(curPw)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }

    //insert
    func insertPWToDB(pw : String) {
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO Password (pw) VALUES (?);"
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let pwString = pw as NSString
            sqlite3_bind_text(insertStatement, 1, pwString.utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    

    //update
    
    @IBAction func finishSetPassword(_ sender: Any) {
        var modeString = ""
        if(modifyMode){
            modeString = "변경"
        }
        else{
            modeString = "설정"
        }
        
        let successAlert =  UIAlertController(title: "비밀번호 \(modeString)이 완료되었습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        let failAlert =  UIAlertController(title: "비밀번호 \(modeString)을 실패했습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        successAlert.addAction(ok)
        failAlert.addAction(ok)
        
        if(modifyMode){
            if(currentPassword.text == currentPw){
                if(repeatedPassword.text != ""){
                    if(newPassword.text == repeatedPassword.text){
                        present(successAlert, animated: true, completion: nil)
                        //비밀번호 sql db에 저장
                        update(curPw: currentPw!, pw: newPassword.text!)
                    }else{
                        present(failAlert, animated: true, completion: nil)
                    }
                }else{
                    present(failAlert, animated: true, completion: nil)
                }
            }
            else{
                present(failAlert, animated: true, completion: nil)
            }
        }
        else{
            if(repeatedPassword.text != ""){
                if(newPassword.text == repeatedPassword.text){
                    present(successAlert, animated: true, completion: nil)
                    //비밀번호 sql db에 저장
                    insertPWToDB(pw: newPassword.text!)
                }else{
                    present(failAlert, animated: true, completion: nil)
                }
            }else{
                present(failAlert, animated: true, completion: nil)
            }
        }
        performSegue(withIdentifier: "deletePwComplete", sender: nil)
    }
    
    @IBAction func checkPasswordSame(_ sender: Any) {
        if(newPassword.text == repeatedPassword.text){
            passwordMessage.text = "비밀번호가 일치합니다."
            passwordMessage.textColor = UIColor(red: 35/256, green: 163/256, blue: 32/256, alpha: 1.0)
            //35 163 32
            
        }else{
            passwordMessage.text = "비밀번호가 일치하지 않습니다."
            passwordMessage.textColor = UIColor(red: 255/256, green: 105/256, blue: 80/256, alpha: 1.0)
            // 255 105 80
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
