//
//  AddToList_ViewController.swift
//  MinZzeungEE
//
//  Created by SungIn on 2019. 4. 25..
//  Copyright © 2019년 SungIn. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddToList_ViewController: UITableViewController {
    
    @IBOutlet weak var sc_idKind: UIView!
    @IBOutlet weak var textField_name: UITextField!
    @IBOutlet weak var textField_idFirsttNum: UITextField!
    @IBOutlet weak var textField_idLastNum: UITextField!
    @IBOutlet weak var imageView_IDCard: UIImageView!
    @IBAction func idKind_change(_ sender: Any) {
        //TODO : pick를 변경하면 view 종류에 맞는 view를 바꿔 띄워준다.
    }
    @IBAction func addCardImage(_ sender:Any){
        //TODO : imageView Click event 달기 -> use UITabGestureRecognizer
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
        //TODO : unwind seg 를 이용하는 방식으로 변경. Don't use this func.
    }
    
    func makeNewID() -> ID?{/*
        guard let newID = ID.init() else{
            return nil
        }
        //TODO : make New ID by using self's field, fill into init()
        return newID
        */
        return nil
    }
    
    @objc
    func imageTapped(img: AnyObject){
        self.performSegue(withIdentifier: "addPhotoSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imageView에 신분증 나타내기 + textView에 추출된 문자 나타내기
        if let idImage = imageView {
            drawFeatures(in: idImage)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(img:)))
        
        imageView_IDCard.isUserInteractionEnabled = true
        imageView_IDCard.addGestureRecognizer(tapGestureRecognizer)
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addDone"{
            //adList가 완벽히 add 되어 seg가 올바르게 전송되었다면
            //self.IDList에 추가
            guard let newID = makeNewID(), let idListController = segue.destination as? MyTableViewController else{
                return
            }
            print("add Done!")
            idListController.idList.append(newID)
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var frameSublayer = CALayer()
    let processor = ScaledElementProcessor()
    
    @IBAction func test(_ sender: Any) {
        let alert =  UIAlertController(title: "신분증 사진을 선택해주세요", message: "선명한 사진 부탁드려요", preferredStyle: .actionSheet)
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
            let alert = UIAlertController(title: "Camera Not Available", message: "A camera is not available. Please try picking an image from the image library instead.", preferredStyle: .alert)
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
            let extractedText = text.split(separator: "\n")
            
            guard let idFirstNum = self.textField_idFirsttNum.text, let idLastNum = self.textField_idLastNum.text, let name = self.textField_name.text else { return }

            //추출정보와 입력정보가 일치한지 확인
            for text in extractedText{
                let idNum = idFirstNum + "-" + idLastNum
                if(String(text) == idNum){
                    print("주민등록번호가 일치합니다")
                    let ref = Database.database().reference()
                    
                    // data 수정
                     ref.child("idData/idFirstNum").setValue("\(idFirstNum)")
                     ref.child("idData/idLastNum").setValue("\(idLastNum)")
                    
                    // data 추가방법
                     ref.childByAutoId().setValue(["name": name, "idFirstNum": idFirstNum, "idLastNum": idLastNum])
                    
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
            }
            
            print(extractedText)
            completion?()
        }
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
        }
        dismiss(animated: true, completion: nil)
    }
}
