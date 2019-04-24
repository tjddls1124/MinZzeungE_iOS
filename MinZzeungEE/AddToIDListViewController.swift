//
//  AddToIDListViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 4. 25..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit

class AddToIDListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
