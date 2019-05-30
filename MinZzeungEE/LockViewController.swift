//
//  LockViewController.swift
//  MinZzeungEE
//
//  Created by admin on 28/05/2019.
//  Copyright © 2019 SungIn. All rights reserved.
//

import UIKit

class LockViewController: UIViewController{

    @IBOutlet weak var passwordIsSame: UITextView!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var password1: UITextField!
    
    
    @IBAction func finishSetPassword(_ sender: Any) {
        let successAlert =  UIAlertController(title: "비밀번호 설정이 완료되었습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        let failAlert =  UIAlertController(title: "비밀번호 설정을 실패했습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        successAlert.addAction(ok)
        failAlert.addAction(ok)
        
        if(passwordIsSame.text == "비밀번호 일치합니다."){
            present(successAlert, animated: true, completion: nil)
        }else{
            present(failAlert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(password1.text == password2.text){
            passwordIsSame.text = "비밀번호가 일치합니다."
            let attributedString = NSMutableAttributedString(string: passwordIsSame.text)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: (passwordIsSame.text as NSString).range(of:passwordIsSame.text))
            passwordIsSame.attributedText = attributedString
           
        }else{
            passwordIsSame.text = "비밀번호가 일치하지 않습니다."
            let attributedString = NSMutableAttributedString(string: passwordIsSame.text)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: (passwordIsSame.text as NSString).range(of:passwordIsSame.text))
            passwordIsSame.attributedText = attributedString
        }
        
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    
//    @IBAction func checkPasswordSame(_ sender: Any) {
//        if(passwordIsSame.text.elementsEqual("비밀번호 일치(모달보려고 기입)")){
//            //unwind
//        }else{
//            let alert =  UIAlertController(title: "비밀번호가 일치 하지 않습니다.", message: "비밀번호를 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
//
//            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//            alert.addAction(ok)
//
//            present(alert, animated: true, completion: nil)
//        }
//    }
}
