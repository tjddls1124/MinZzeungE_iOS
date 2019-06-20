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


extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }

    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }

    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }

    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}

class DetailViewController: UIViewController {
    /*var parameters: Parameters = [
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
    ]*/

    @IBOutlet weak var idImageView : UIImageView?
    var id : ID?

    @IBOutlet weak var authResultIcon: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBAction func authen(_ sender: Any) {
        performSegue(withIdentifier: "authenSegue", sender: nil)
    }
    @IBOutlet weak var authResult: UILabel!
    func convertIDtoParm(id : ID, num: Int) -> Parameters?{


         let str = id.enrollDate.split(separator: "-")
        if(str.count != 4){
            print("Error")
            return nil
        }

        let split = str[0].split(separator: ":")
        let parameters: Parameters = [

            "checkPage": 2,
            "flag": "searchPage",
            "regYear": "19\(id.idFirstNum[0..<2])",
            "regMonth": String(id.idFirstNum[2..<4]),
            "regDate": String(id.idFirstNum[4..<6]), // date should be 2-digit number
            "name": id.name,
            "licenNo0": String(split[num]), // 2-digit
            "licenNo1": String(str[1]), // 2-digit
            "licenNo2": String(str[2]), // 6-digit
            "licenNo3": String(str[3]), // 2-digit
            // above four numbers make up the full license number
            "ghostNo": "5747AP" // code written under the picture; 6-length string
        ]
        /*
        parameters["regYear"] =
        parameters["regYear"] =
        parameters["regYear"] =
        parameters["name"] =



        {

            parameters["licenNo0"] = str[0]
            parameters["licenNo1"] = str[1]
            parameters["licenNo2"] = str[2]
            parameters["licenNo3"] = str[3]
        }
         */
        return parameters
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.spinner.startAnimating()
        let parameters = convertIDtoParm(id: self.id!, num:0)
        /* To allow custom request bDetailViewControllerld add `App Transport Security Settings` option in info.plist */
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

                    if (resultMsg == "전산 자료와 일치 합니다." || resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치합니다." || resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치하지 않니다.") {
                        //TODO : id valid 변경할 것
                        self.checkFlag = true

                        Thread.sleep(forTimeInterval: 3)
                        self.spinner.stopAnimating()

                        print("success")
                        self.authResult.text = "유효한 신분증입니다."
                        self.authResultIcon.image = UIImage(named: "successAuth")
                    } else {
                        // one more
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

                                    if (resultMsg == "전산 자료와 일치 합니다." || resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치합니다." || resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치하지 않니다.") {
                                        //TODO : id valid 변경할 것
                                        print("success")
                                        self.checkFlag = true

                                        Thread.sleep(forTimeInterval: 3)
                                        self.spinner.stopAnimating()

                                        self.authResult.text = "유효한 신분증입니다."
                                        self.authResultIcon.image = UIImage(named: "successAuth")
                                    } else {
                                        print("fail")
                                        Thread.sleep(forTimeInterval: 3)
                                        self.spinner.stopAnimating()

                                        self.authResult.text = "유효한 신분증이 아닙니다."
                                        self.authResultIcon.image = UIImage(named: "failAuth")
                                    }
                                } catch {

                                }
                        }
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


//
//if (resultMsg == "전산 자료와 일치 합니다." || resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치합니다." || resultMsg == "전산 자료와 일치 합니다.\n식별번호가 일치하지 않니다.") {
//    //TODO : id valid 변경할 것
//    Thread.sleep(forTimeInterval: 3)
//    self.spinner.stopAnimating()
//
//    print("success")
//    self.authResult.text = "유효한 신분증입니다."
//    self.authResultIcon.image = UIImage(named: "successAuth")
//} else {
//    print("fail")
//    Thread.sleep(forTimeInterval: 3)
//    self.spinner.stopAnimating()
//
//    self.authResult.text = "유효한 신분증이 아닙니다."
//    self.authResultIcon.image = UIImage(named: "failAuth")
//}

//
//[
//    "checkPage": 2,
//    "flag": "searchPage",
//    "regYear": parameters!["reqYear"] as! String,
//    "regMonth": parameters!["reqMonth"] as! String,
//    "regDate": parameters!["reqDate"] as! String, // date should be 2-digit number
//    "name": parameters!["name"] as! String,
//    "licenNo0": parameters!["licenNo0-0"] as! String, // 2-digit
//    "licenNo1": parameters!["licenNo1"] as! String, // 2-digit
//    "licenNo2": parameters!["licenNo2"] as! String, // 6-digit
//    "licenNo3": parameters!["licenNo3"] as! String, // 2-digit
//    // above four numbers make up the full license number
//    "ghostNo": parameters!["ghostNo"] as! String // code written under the picture; 6-length string
//]
