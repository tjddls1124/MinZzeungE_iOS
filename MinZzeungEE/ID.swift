//
//  ID.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 3. 28..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import Foundation
import Firebase
import UIKit

struct ID{
    init(kindKor:String,name:String,idFirstNum:String,idLastNum:String,enrollDate:String,image:UIImage, valid:Bool){
        self.kind = korString_toIdKind(korString: kindKor)
        self.name = name
        self.idFirstNum = idFirstNum
        self.idLastNum = idLastNum
        self.enrollDate = enrollDate
        self.imageFilePath = image
        self.isVaild = valid
    }
    //make id from sqlite DB
    init(idNum:String) {
        var kindKor : String = ""
        var isVaild : Bool = false
        var name : String = ""
        var enrollDate : String = ""
        var image : UIImage?
        let ref = Database.database().reference()
        ref.child("idData").child("\(idNum)").observeSingleEvent(of: .value, with:{
            (snapshot) in
            let value = snapshot.value as! NSDictionary
            kindKor = value["kind"] as! String
             isVaild = value["isVaild"] as! Bool
             name = value["name"] as! String
            enrollDate = value["enrollDate"] as! String
        }){(error) in
            print (error.localizedDescription)
        }
        var kind = idKind.DriverLicense
        kind = korString_toIdKind(korString: kindKor)
        self.kind = kind
        self.enrollDate = enrollDate
        self.name = name
        var idSp = idNum.split(separator: "-")
        self.idFirstNum = String(idSp[0])
        self.idLastNum = String(idSp[1])
        self.isVaild = isVaild
        
        //Load UIImage
        let imageRef = Storage.storage().reference().child("images/\(idNum).jpg")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data , error in
            // Data for "images/island.jpg" is returned
            image = UIImage(data: data!)!
        }
        self.imageFilePath = image!
    }
    
    
    var kind : idKind! = idKind.DriverLicense
    var name : String = ""
    var idFirstNum : String = ""
    var idLastNum : String = ""
    var enrollDate : String = ""
    var imageFilePath : UIImage = UIImage(named:"driver_license")!
    var isVaild : Bool = false
    
    enum idKind{
        case ID_Card
        case DriverLicense
        case StudentID_Card
        case Passport
        var idKindString : String{ //Enum Type을 이용하여 String Value를 구해줌. Computed Property, 메모리를 가지고 있지 않다가 계산후에 부여해줌.
            get{
                let kindString : String
                switch self {
                case .Passport:
                    kindString = "Passport"
                case .ID_Card:
                    kindString = "ID Card"
                case .DriverLicense:
                    kindString = "Driver License"
                case .StudentID_Card:
                    kindString = "Student ID Card"
                }
                return kindString
            }
        }
        var idKind_korString : String{ // Enum Type을 이용해 ID_Kind 의 한국어 String 을 구해줌.
            get{
                let kind_korString : String
                    switch self {
                    case .Passport :
                        kind_korString = "여권"
                    case .DriverLicense:
                        kind_korString = "운전면허증"
                    case .ID_Card:
                        kind_korString = "주민등록증"
                    case .StudentID_Card:
                        kind_korString = "학생증"
                    }
                    return kind_korString
            }
        }

    }
    func korString_toIdKind(korString : String) -> idKind{
        switch korString {
        case "여권":
            return .Passport
        case "운전면허증" :
            return .DriverLicense
        case "주민등록증" :
            return .ID_Card
        case "학생증":
            return .StudentID_Card
        case "Driver License":
            return .DriverLicense
        case "ID Card":
            return .ID_Card
        case "Passport" :
            return .Passport
        case "StudentID Card":
            return .StudentID_Card
        default:
            return .DriverLicense
        }
    }
}

