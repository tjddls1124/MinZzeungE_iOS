//
//  DetailViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 4. 19..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit
import Alamofire // HTTP Request and Response
import Kanna

/*
 * Driver License required info:
 * Name, BirthYear-BirthMonth-BirthDay, License No., GhostNo.
 * Also, additional parameters called `checkPage` and `flag` are needed
 */

let parameters: Parameters = [
    "checkPage": 2,
    "flag": "searchPage",
    "regYear": 1999,
    "regMonth": 01,
    "regDate": 01, // date should be 2-digit number
    "name": "홍길동",
    "licenNo0": 11, // 2-digit
    "licenNo1": 11, // 2-digit
    "licenNo2": 111111, // 6-digit
    "licenNo3": 11, // 2-digit
    // above four numbers make up the full license number
    "ghostNo": "AAAAAA" // code written under the picture; 6-length string
]

class DetailViewController: UIViewController {
    @IBOutlet weak var idImageView : UIImageView?
    var id : ID?
    
    @IBOutlet weak var authResultIcon: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func authen(_ sender: Any) {
        performSegue(withIdentifier: "authenSegue", sender: nil)
    }
    @IBOutlet weak var authResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        /* To allow custom request by Alamofire, you should add `App Transport Security Settings` option in info.plist */
        AF.request("http://www.efine.go.kr/licen/truth/licenTruth.do?subMenuLv=010100", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseString{ response in
                // Parse only the result of verification part from the response
                do {
                    let doc = try HTML(html: response.result.get(), encoding: .utf8)
                    let elements = doc.css("#licen-truth").first!.css("tr td b")
                    var msgs: Array<String> = []
                    var resultMsg: String = ""
                    self.authResult.numberOfLines = 0
                    for msg in elements {
                        if let msgNode = msg.css("font").first {
                            msgs.append(msgNode.text!)
                        }
                    }
                    for i in 0 ..< msgs.count - 1 {
                        resultMsg = resultMsg + msgs[i] + "\n"
                    }
                    resultMsg = resultMsg + msgs[msgs.count-1]
                    self.spinner.stopAnimating()
                    
                    if resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치합니다." {
                        //TODO : id valid 변경할 것
                        print("success")
                        self.authResult.text = "유효한 신분증입니다."
                        self.authResultIcon.image = UIImage(named: "auth_success")
                    } else {
                        print("fail")
                        
                        self.authResult.text = "유효한 신분증이 아닙니다."
                        self.authResultIcon.image = UIImage(named: "auth_fail")
                    }
                    
                } catch {

                }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        idImageView?.image = id!.imageFilePath
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
