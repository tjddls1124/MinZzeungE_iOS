//
//  ID.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 3. 28..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import Foundation

struct ID{
    var kind : idKind
    var name : String
    var idFirstNum : String
    var idLastNum : String
    var enrollDate : String
    var imageFilePath : String
    var isVaild : Bool
}

enum idKind{
    case ID_Card,DriverLicense
}
