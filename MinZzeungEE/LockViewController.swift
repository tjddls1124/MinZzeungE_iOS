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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if(password1.text == password2.text){
            passwordIsSame.text = "비밀번호 일치"
            let attributedString = NSMutableAttributedString(string: passwordIsSame.text)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: (passwordIsSame.text as NSString).range(of:passwordIsSame.text))
            passwordIsSame.attributedText = attributedString
           
        }else{
            passwordIsSame.text = "비밀번호 불일치"
            let attributedString = NSMutableAttributedString(string: passwordIsSame.text)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: (passwordIsSame.text as NSString).range(of:passwordIsSame.text))
            passwordIsSame.attributedText = attributedString
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    

}
