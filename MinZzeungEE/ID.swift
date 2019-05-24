//
//  ID.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 3. 28..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import Foundation
import UIKit

struct ID{
    var kind : idKind
    var name : String
    var idFirstNum : String
    var idLastNum : String
    var enrollDate : String
    var imageFilePath : UIImage
    var isVaild : Bool
    
    enum idKind{
        case ID_Card
        case DriverLicense
        case StudentID_Card
        var idKindString : String{ //Enum Type을 이용하여 String Value를 구해줌. Computed Property, 메모리를 가지고 있지 않다가 계산후에 부여해줌.
            get{
                let kindString : String
                switch self {
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
}

