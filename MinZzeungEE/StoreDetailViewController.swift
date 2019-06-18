//
//  StoreDetailViewController.swift
//  MinZzeungEE
//
//  Created by cadenzah on 17/06/2019.
//  Copyright © 2019 SungIn. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {

    var storeTitle: String!
    var storeSnippet: String!
    
    @IBOutlet weak var storeTitleView: UILabel!
    @IBOutlet weak var storeSnippetView: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        storeTitleView!.text = storeTitle
        storeSnippetView!.text = storeSnippet
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
