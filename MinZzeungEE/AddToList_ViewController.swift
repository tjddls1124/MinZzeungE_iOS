//
//  AddToList_ViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 4. 25..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SQLite3

class AddToList_ViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var modIndex : Int = -1
    var idImage = UIImage(named:"driver_license")
    var idNumValid : Bool = false
    var enrollNumVaild : Bool = false
    var extractedText : [Substring]?
    
    @IBOutlet weak var selectedSegment: UISegmentedControl!
    @IBOutlet weak var sc_idKind: UIView!
    @IBOutlet weak var textField_name: UITextField!
    @IBOutlet weak var textField_idFirsttNum: UITextField!
    @IBOutlet weak var textField_idLastNum: UITextField!
    @IBOutlet weak var imageView_IDCard: UIImageView!
    @IBOutlet weak var firstLisenceNumber: UITextField!
    @IBOutlet weak var secondLisenceNumber: UITextField!
    @IBOutlet weak var lawText: UITextView!
    
    @IBOutlet weak var locatinImage: UIImageView!
    @IBOutlet weak var secondEnrolllLabel: UILabel!
    @IBOutlet weak var firstEnrollLabel: UILabel!
    @IBOutlet weak var thirdLisenceNumber: UITextField!
    @IBAction func idKind_change(_ sender: Any) {
        
        var this = ""
        
        
         
         if(self.selectedSegment.selectedSegmentIndex==0){
         
         this = "주민등록증"
         
         }
         
         else if(self.selectedSegment.selectedSegmentIndex==2){
         
         this = "여권"
         
         }
         
         if(self.selectedSegment.selectedSegmentIndex == 1){
         
         viewChangeBySeg(isHide: false)
         
         }
         
         
         
         else{
         
         let alert = UIAlertController(title: "\(this) 인증 서비스 준비중", message: "현재 \(this) 인증 서비스는 준비중입니다.\n등록 이후 신분증 인증이 되지 않으니 참고해주세요.", preferredStyle: UIAlertController.Style.alert)
         
         let action = UIAlertAction(title: "확인", style: .default, handler: nil)
         
         
         
         alert.addAction(action)
         
         present(alert, animated: true, completion: nil)
         
         viewChangeBySeg(isHide: true)
         
         }
    }
    func viewChangeBySeg(isHide : Bool){
        //pick를 변경하면 view 종류에 맞는 view를 바꿔 띄워준다.
        self.firstLisenceNumber.isHidden = isHide
        self.secondLisenceNumber.isHidden = isHide
        self.thirdLisenceNumber.isHidden = isHide
        self.firstEnrollLabel.isHidden = isHide
        self.secondEnrolllLabel.isHidden = isHide
        self.locationPicker.isHidden = isHide
        self.locatinImage.isHidden = isHide
    }
    
    
    @IBAction func modalDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func AddComplete(_ sender: Any) {
        //TODO : if 문으로 Obj들이 올바르게 들어오는지 체크.
        //TODO : 올바르게 들어왓다면 List에 추가하고 modal을 dismiss
        //TODO : 아니라면 예외처리 후 다시 입력하라는 메시지 띄우기
        //TODO : console 출력 -> message 띄우기로 바꿀 것
        //TODO : unwind seg 를 이용하는 방식으로 변경.
        //Don't use this func.
    }
   
    func makeNewID(kind:String, name:String, idFirst:String,idLast:String,enrollDate : String,img:UIImage, valid:Bool) -> ID?{
        guard let newID = ID.init(kindKor: kind, name: name, idFirstNum: idFirst, idLastNum: idLast, enrollDate: enrollDate, image: img, valid: valid) as ID! else{
            return nil
        }
        //TODO : make New ID by using self's field, fill into init()
        return newID
    }
    
    
    func appendToFirebase(){

    }
    
    //read
    func selectQuery(pk : String) -> ID?{
        let queryStatementString = "SELECT * FROM ID Where imagePath = '\(pk)';"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let queryResultCol1 = sqlite3_column_text(queryStatement, 0)
                let kind = String(cString: queryResultCol1!)
                let queryResultCol2 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol2!)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 2)
                let idFirstNum = String(cString: queryResultCol3!)
                let queryResultCol4 = sqlite3_column_text(queryStatement, 3)
                let idLastNum = String(cString: queryResultCol4!)
                let queryResultCol5 = sqlite3_column_text(queryStatement, 4)
                let enrollDate = String(cString: queryResultCol5!)
                let queryResultCol6 = sqlite3_column_text(queryStatement, 5)
                let imgPath = String(cString: queryResultCol6!)
                let queryResultCol7 = sqlite3_column_text(queryStatement, 6)
                let valid = sqlite3_column_int(queryStatement, 7)
                print("Query Result:")
                print("\(name)")
                
                //image file load
                let curPath = getDocumentsDirectory()
                let fileURL = curPath.appendingPathComponent("\(imgPath).png")
                let data = try? Data(contentsOf: fileURL)
                let img = UIImage(data: data!)!
                var val : Bool = true
                if (valid == 0){
                    val = false
                }
                sqlite3_finalize(queryStatement)
                return ID.init(kindKor: kind, name: name, idFirstNum: idFirstNum, idLastNum: idLastNum, enrollDate: enrollDate, image: img, valid: val)
                
            }
            else{
                print("select : no result")
                sqlite3_finalize(queryStatement)
                return nil
            }
        }
        sqlite3_finalize(queryStatement)
        return nil
    }

    //중복된 데이터가 있는지 확인
    func checkDup(imgPath : String) -> Bool {
        let id = selectQuery(pk: imgPath)
        return id != nil
    }
    
    func checkVaild() -> Bool{
        guard let idFirstNum = self.textField_idFirsttNum.text else{
            return true }
        guard let idLastNum = self.textField_idLastNum.text, let name = self.textField_name.text else {
            return true
        }
        guard let enrollFirstD = self.firstLisenceNumber.text, let enrollSecondD =  self.secondLisenceNumber.text , let enrollThirdD = self.thirdLisenceNumber.text else {
            return true
        }
        
        //추출정보와 입력정보가 일치한지 확인
        for text in self.extractedText!{
            print("text :\(text)")
            let idNum = idFirstNum + "-" + idLastNum
            if(String(text).contains(idNum)){
                self.idNumValid = true
                print("주민등록번호가 일치합니다")
                
                //let ref = Database.database().reference()
                
                // data 수정
                //ref.child("idData/idFirstNum").setValue("\(idFirstNum)")
                //ref.child("idData/idLastNum").setValue("\(idLastNum)")
                
                // data 추가방법
                
                //  ref.childByAutoId().setValue(["name": name, "idFirstNum": idFirstNum, "idLastNum": idLastNum, "idImage": self.idImage]) //add image in DB
                
                // data 읽어오기
                //                    ref.child("idData").observeSingleEvent(of: .value, with: {
                //                        (snapsot) in if let idData = snapsot.value as? [String:Any]{
                //                            print(idData["name"]!)
                //                            print(idData["idFirstNum"]!)
                //                            print(idData["idLastNum"]!)
                //                        }
                //                    })
                // https://firebase.google.com/docs/database/ios/read-and-write?hl=ko
                
            }
            let enrollD = enrollFirstD + "-" + enrollSecondD + "-" + enrollThirdD
            if(String(text).contains(enrollD)){
                self.enrollNumVaild = true
                print("등록번호가 일치합니다")
            }
            
        }

        
        if(self.selectedSegment.selectedSegmentIndex == 1){
            if(idNumValid && enrollNumVaild){
                return false
            }
            else{
                return true
            }
        }
        else if(idNumValid){
            return false
        }
        
        
        return true
    }
    
    @IBAction func checkAndDone(_ sender: Any) {
        
        let uid = "\(self.textField_idFirsttNum.text!)-\(self.textField_idLastNum.text! )-\(getKindString(index: self.selectedSegment.selectedSegmentIndex))"
        
        // image valildation
        if(idImage == UIImage(named:"driver_license")){ //사진이 변경되지 않았다면
            let alert = UIAlertController(title: "사진 오류", message: "사진이 추가되지 않았습니다.\n 다시 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        else if(checkVaild()){
            let alert = UIAlertController(title: "신분증 정보 오류", message: "신분증 정보가 사진과 다르거나 올바르게 입력되지 않았습니다.\n 다시 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            //let disAction = UIAlertAction(title:"취소", style: .default, handler: nil)
            alert.addAction(action)
            //alert.addAction(disAction)
            present(alert, animated: true, completion: nil)
        }
        else if(checkDup(imgPath: uid) && modIndex == -1){ //수정모드가 아니고 중복된 신분증을 등록
            let alert = UIAlertController(title: "신분증 중복 오류", message: "이미 같은 주민등록번호로 등록된 같은종류의 신분증이 있습니다!\n 해당 신분증을 수정해주세요.", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            //let disAction = UIAlertAction(title:"취소", style: .default, handler: nil)
            alert.addAction(action)
            //alert.addAction(disAction)
            present(alert, animated: true, completion: nil)
        }
            
        else if(modIndex != -1){
            let alert = UIAlertController(title: "신분증 수정", message: "해당 신분증의 내용을\n 수정하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: {
                (action) in
                self.performSegue(withIdentifier: "Modify", sender: nil)
            })
            let disAction = UIAlertAction(title:"취소", style: .default, handler: nil)
            alert.addAction(action)
            alert.addAction(disAction)
            present(alert, animated: true, completion: nil)
        }
        
        else{
            performSegue(withIdentifier: "Done", sender: nil)
        }
    }
    @objc
    func imageTapped(img: AnyObject){
        self.performSegue(withIdentifier: "addPhotoSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField_name.delegate = self as? UITextFieldDelegate
        textField_idLastNum.delegate = self as? UITextFieldDelegate
        textField_idFirsttNum.delegate = self as? UITextFieldDelegate
        firstLisenceNumber.delegate = self as? UITextFieldDelegate
        secondLisenceNumber.delegate = self as? UITextFieldDelegate
        thirdLisenceNumber.delegate = self as? UITextFieldDelegate
        lawText.delegate = self as? UITextViewDelegate
        locationPicker.delegate = self
        locationPicker.dataSource = self
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))


        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification,
                                             object: nil)


        addPhotoButton.setTitle("Click here to add photo",for: .normal)
        //imageView에 신분증 나타내기 + textView에 추출된 문자 나타내기
        if let idImage = imageView {
            drawFeatures(in: idImage)
        }

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(img:)))

        imageView_IDCard.isUserInteractionEnabled = true
        imageView_IDCard.addGestureRecognizer(tapGestureRecognizer)
        
        //if modify
        if(self.modIndex != -1){
            let id = idList[modIndex]
            switch id.kind {
            case .DriverLicense?: self.selectedSegment.selectedSegmentIndex = 1
            case .ID_Card?: self.selectedSegment.selectedSegmentIndex = 0
            case .Passport?: self.selectedSegment.selectedSegmentIndex = 2
            //default : Driver License
            case .none:
                self.selectedSegment.selectedSegmentIndex = 1
            case .some(.StudentID_Card):
                self.selectedSegment.selectedSegmentIndex = 1
            }
            //self.imageView.image = id.imageFilePath
            //self.idImage = id.imageFilePath
            self.textField_name.text = id.name
            self.textField_idLastNum.text = id.idLastNum
            self.textField_idFirsttNum.text = id.idFirstNum
            let s = id.enrollDate.split(separator: "-")
            if(s.count >= 4){
                self.firstLisenceNumber.text = String(s[1])
                self.secondLisenceNumber.text = String(s[2])
                self.thirdLisenceNumber.text = String(s[3])
            }
            else{
                viewChangeBySeg(isHide: true)
            }
            
            //TODO : Modify seleceted segment index
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation



/
*/
    //update
    //CREATE TABLE ID(Kind CHAR(20) , Name CHAR(20), IdFirstNum CHAR(20) , IdLastNum CHAR(20), EnrollDate Char(30), imagePath Char(255) PRIMARY KEY NOT NULL , valid INTEGER);
    func update(pk : String, id : ID) {
        let idKindString = id.kind.idKindString //as NSString
        let idName = id.name //as NSString
        let idFirstNum = id.idFirstNum// as NSString
        let idLastNum = id.idLastNum //as NSString
        let enrollD = id.enrollDate //as NSString
        let ipath = "\(id.idFirstNum)-\(id.idLastNum)-\(id.kind.idKindString)" //as NSString
        var validInt = 0
        if(id.isVaild){
            validInt = 1
        }
        
        let updateStatementString = "UPDATE ID SET kind = '\(idKindString)', Name = '\(idName)', IdFirstNum = '\(idFirstNum)', IdLastNum = '\(idLastNum)' , EnrollDate = '\(enrollD)', imagePath = '\(ipath)', vaild = \(validInt) WHERE imagePath = '\(pk)';"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    //insert
    func insertIDtoDB(id : ID) {
        var insertStatement: OpaquePointer? = nil
        var validInt = 0
        if(id.isVaild){
            validInt = 1
        }
        
        let insertStatementString = "INSERT INTO ID (Kind, Name, IdFirstNum, IdLastNum, EnrollDate, imagePath, valid) VALUES (?, ?, ?, ?, ?, ?, ?);"
        //print(insertStatementString)
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let idKindString = id.kind.idKindString as NSString
            let idName = id.name as NSString
            let idFirstNum = id.idFirstNum as NSString
            let idLastNum = id.idLastNum as NSString
            let enrollD = id.enrollDate as NSString
            let ipath = "\(id.idFirstNum)-\(id.idLastNum)-\(id.kind.idKindString)" as NSString
            sqlite3_bind_text(insertStatement, 1, idKindString.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, idName.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, idFirstNum.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, idLastNum.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, enrollD.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, ipath.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, Int32(validInt))

            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    
    func getKindString(index : Int) ->String{
        var kindString = ""
        switch index {
        case 0 : kindString = "ID Card"
        case 1 : kindString = "Driver License"
        case 2 : kindString = "Passport"
        default:
            kindString = "Driver License"
        }
        return kindString
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Modify"{
            //create NewID
            let uid = "\(self.textField_idFirsttNum.text!)-\(self.textField_idLastNum.text! )-\(getKindString(index: self.selectedSegment.selectedSegmentIndex))"
            var kindString = ""
            kindString = getKindString(index: selectedSegment.selectedSegmentIndex)
            guard let newID = makeNewID(kind: kindString, name: self.textField_name.text!, idFirst: self.textField_idFirsttNum.text!, idLast: self.textField_idLastNum.text!, enrollDate: "\(self.pickedNumber)-\(self.firstLisenceNumber.text!)-\(self.secondLisenceNumber.text!)-\(self.thirdLisenceNumber.text!)", img: self.idImage!, valid: false), let _ = segue.destination as? MyTableViewController else{
                return
            }
            //modify list
            idList[modIndex] = newID
            //modify DB
            update(pk: uid, id: newID)
        }
        if segue.identifier == "Done"{
            //adList가 완벽히 add 되어 seg가 올바르게 전송되었다면
            //self.IDList에 추가

            //let dest = segue.destination as! MyTableViewController
            //TODO : kind check
            //TODO : text field optional check
            //TODO : check equality with parsed text
            var kindString = ""
            kindString = getKindString(index: selectedSegment.selectedSegmentIndex)
            guard let newID = makeNewID(kind: kindString, name: self.textField_name.text!, idFirst: self.textField_idFirsttNum.text!, idLast: self.textField_idLastNum.text!, enrollDate: "\(self.pickedNumber)-\(self.firstLisenceNumber.text!)-\(self.secondLisenceNumber.text!)-\(self.thirdLisenceNumber.text!)", img: self.idImage!, valid: false), let _ = segue.destination as? MyTableViewController else{
                return
            }
            idList.append(newID)
            
            
            //save data to sqlite db
            insertIDtoDB(id: newID)
            let uid = "\(newID.idFirstNum)-\(newID.idLastNum)-\(newID.kind.idKindString)"
            //이미지를 로컬에 저장
            if let image = idImage {
                if let data = image.pngData() {
                    let filename = getDocumentsDirectory().appendingPathComponent("\(uid).png")
                    try? data.write(to: filename)
                }
            }
            
            
            /*
            // Create a child reference
            // imagesRef now points to "images"
            //let uid = Auth.auth().currentUser?.uid
            var thisImageView = idImage
            //storageRef = StorageReference.storage().reference()
            let storageRef = Storage.storage().reference()
            let imagesRef = storageRef.child("images")
            let idImageRef = imagesRef.child("\(uid).jpg")

            let uploadTask = idImageRef.putData(idImgData!,metadata: nil)
            */
        }
    }
    
    
    
    
    /**
     현재 directory url을 가져옴.
     */
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    var frameSublayer = CALayer()
    let processor = ScaledElementProcessor()

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBAction func test(_ sender: Any) {
        //addPhotoButton.isHidden = true
        addPhotoButton.setTitle("",for: .normal)
        
        let alert =  UIAlertController(title: "신분증 사진을 선택해주세요", message: "", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    func openLibrary(){
        presentImagePickerController(withSourceType: .photoLibrary)
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentImagePickerController(withSourceType: .camera)
        } else{
            let alert = UIAlertController(title: "Camera Not Available", message: "A camera is not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    private func removeFrames() {
        guard let sublayers = frameSublayer.sublayers else { return }
        for sublayer in sublayers {
            sublayer.removeFromSuperlayer()
        }
    }

    // image에서 text정보 추출
    private func drawFeatures(in imageView: UIImageView, completion: (() -> Void)? = nil) {
        removeFrames()
        processor.process(in: imageView) { text, elements in
//            self.textView.text = text
            //추출된 정보 배열로 저장
            self.extractedText = text.split(separator: "\n")
 
            completion?()
        }
    }

//    func uploadImageToFirebaseStorage(data: NSData){
//        let storageRef = Storage.storage().reference(withPath: "tmp1.png")
//        let uploadMetadata = StorageMetadata()
//        uploadMetadata.contentType = "image/jpeg"
//
//        storageRef.putData(data as Data, metadata: uploadMetadata, completion: {(metadata, error) in
//            if(error != nil){
//                print("error /(error?.locaizedDescription)")
//            }else{
//                print("Upload Complete!")
//            }
//        })
//
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ sender:Notification){
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender:Notification){
        self.view.frame.origin.y = 0
    }
    
    @objc func endEditing(){
        textField_name.resignFirstResponder()
        textField_idLastNum.resignFirstResponder()
        textField_idFirsttNum.resignFirstResponder()
        firstLisenceNumber.resignFirstResponder()
        secondLisenceNumber.resignFirstResponder()
        thirdLisenceNumber.resignFirstResponder()
        lawText.resignFirstResponder()
    }
    
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var locationName: UITextField!
    
    var locationData = ["없음", "서울:11", "부산:12", "경기:13", "강원:14", "충북:15", "충남:16", "전북:17", "전남:18", "경북:19", "경남:20", "제주:21", "대구:22", "인천:23", "광주:24", "대전:25", "울산:26"]
    var pickedNumber:String = ""
    var pickedIndex:Int = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationData[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return locationData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedIndex = row
        pickedNumber = locationData[row]
        print(pickedNumber)
    }
}

extension AddToList_ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // 카메라, 사진첩 접근
    private func presentImagePickerController(withSourceType sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }

    // 카메라or사진첩에서 가져온 image를 화면에 출력
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            let fixedImage = pickedImage.fixOrientation()
            imageView.image = fixedImage
            drawFeatures(in: imageView)
            
            idImage = fixedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
