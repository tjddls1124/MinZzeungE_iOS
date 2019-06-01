//
//  LockViewController.swift
//  MinZzeungEE
//
//  Created by admin on 28/05/2019.
//  Copyright © 2019 SungIn. All rights reserved.
//

import UIKit

class LockViewController: UIViewController{

    @IBOutlet weak var passwordMessage: UITextView!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatedPassword: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finishSetPassword(_ sender: Any) {
        let successAlert =  UIAlertController(title: "비밀번호 설정이 완료되었습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        let failAlert =  UIAlertController(title: "비밀번호 설정을 실패했습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        successAlert.addAction(ok)
        failAlert.addAction(ok)
        
        //    var dbPassword: Int = 1234
        //    if(currentPassword.text == dbPassword){
        //          present(failAlert, animated: true, completion: nil)
        //
        //    }
        
        if(newPassword.text == repeatedPassword.text){
            present(successAlert, animated: true, completion: nil)
            //비밀번호 db에 저장
        }else{
            present(failAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkPasswordSame(_ sender: Any) {
        if(newPassword.text == repeatedPassword.text){
            passwordMessage.text = "비밀번호가 일치합니다."
            //35 163 32
            
        }else{
            passwordMessage.text = "비밀번호가 일치하지 않습니다."
            // 255 105 80
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
