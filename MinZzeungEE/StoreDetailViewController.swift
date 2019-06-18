//
//  StoreDetailViewController.swift
//  MinZzeungEE
//
//  Created by cadenzah on 17/06/2019.
//  Copyright © 2019 SungIn. All rights reserved.
//

import UIKit
import Firebase

// spinner view for entire screen
var vSpinner1 : UIView?
// spinner view for image view
var vSpinner2 : UIView?

class StoreDetailViewController: UIViewController {

    var storeTitle: String!
    var storeId: String!
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeTitleView: UILabel!
    @IBOutlet weak var storeAddressView: UILabel!
    @IBOutlet weak var storeSnippetView: UILabel!
    @IBOutlet weak var storeDescView: UILabel!
    
    var refDB: DatabaseReference!
    var refSR: StorageReference!
    
    @IBOutlet var thisView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vSpinner1 = self.showSpinner(onView: thisView, spinner: vSpinner1)
        
        self.storeTitleView!.text = storeTitle
        
        
        // 추가 데이터 로드
        self.refDB = Database.database().reference()
        self.refDB.child("stores/\(self.storeTitle!)").observe(.value, with: {(snapshot) in
            
            self.removeSpinner(spinner: vSpinner1)
            vSpinner1 = nil
            let info = snapshot.value as? [String: AnyObject] ?? [:]
            
            self.storeAddressView!.text = info["address"] as? String
            self.storeSnippetView!.text = info["snippet"] as? String
            
            // spinner 전환; 텍스트 정보 -> 이미지
            vSpinner2 = self.showSpinner(onView: self.storeImageView, spinner: vSpinner2)
            // 이미지 로드 시작
            self.refSR = Storage.storage().reference().child("stores/large")
            let imageRef = self.refSR.child("\(self.storeId!).jpeg")
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, err in
                if let error = err {
                    print(error)
                } else {
                    let image = UIImage(data: data!)
                    self.storeImageView!.image = image
                    self.storeImageView!.contentMode = .scaleAspectFill
                    self.removeSpinner(spinner: vSpinner2)
                    vSpinner2 = nil
                }
            }
        })
    }
}

extension UIViewController {
    func showSpinner(onView : UIView, spinner: UIView?) -> UIView? {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    func removeSpinner(spinner: UIView?) {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
        }
    }
}
