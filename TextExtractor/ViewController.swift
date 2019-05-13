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
    @IBOutlet weak var cameraButton: UIButton!
    
    var frameSublayer = CALayer()
    let processor = ScaledElementProcessor()
    var scannedText: String = "" {
        didSet {
            textView.text = scannedText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.addSublayer(frameSublayer)
        drawFeatures(in: imageView)
    }
    
    // MARK: Actions
    @IBAction func cameraDidTouch(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentImagePickerController(withSourceType: .camera)
        } else {
            let alert = UIAlertController(title: "Camera Not Available", message: "A camera is not available. Please try picking an image from the image library instead.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func libraryDidTouch(_ sender: UIButton) {
        presentImagePickerController(withSourceType: .photoLibrary)
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
            self.scannedText = text
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
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            let fixedImage = pickedImage.fixOrientation()
            imageView.image = fixedImage
            drawFeatures(in: imageView)
        }
        dismiss(animated: true, completion: nil)
    }
}
