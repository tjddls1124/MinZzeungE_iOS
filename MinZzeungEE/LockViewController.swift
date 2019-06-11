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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finishSetPassword(_ sender: Any) {
        let successAlert =  UIAlertController(title: "비밀번호 설정이 완료되었습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        let failAlert =  UIAlertController(title: "비밀번호 설정을 실패했습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        successAlert.addAction(ok)
        failAlert.addAction(ok)
        
        if(repeatedPassword.text != ""){
            if(newPassword.text == repeatedPassword.text){
                present(successAlert, animated: true, completion: nil)
                //비밀번호 db에 저장
                //setSucessful = true;
                //setSucessful is true -> 인증버튼 클릭시 비밀번호 입력 모달창 나타나기
            }else{
                present(failAlert, animated: true, completion: nil)
            }
        }else{
            present(failAlert, animated: true, completion: nil)
        }
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
