//
//  ViewController.swift
//  TextExtractor
//
//  Created by Mobdev125 on 3/18/19.
//  Copyright © 2019 Mobdev125. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var idSegment: UISegmentedControl!
    
    var frameSublayer = CALayer()
    let processor = ScaledElementProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawFeatures(in: imageView)
    }
    
    @IBAction func test(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
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
            self.textView.text = text
            
            let extractedText = text.split(separator: "\n")
            print(extractedText)
            //if segement 주민등록증 or 운전면허증 따라서 배열 비교값 바뀜
            completion?()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
