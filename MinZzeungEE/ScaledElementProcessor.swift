
import Firebase

struct ScaledElement {
    let frame: CGRect
  //  let shapeLayer: CALayer
}

class ScaledElementProcessor {
    let vision = Vision.vision()
    var textRecognizer: VisionTextRecognizer!
    
    init() {
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    func process(
        //클로져 밖에서도 사용하기 위해서 escaping사용
        in imageView: UIImageView,
        callback: @escaping (_ text: String, _ scaledElements: [ScaledElement]) -> Void
        ) {
        
    guard let image = imageView.image else { return }
    //api의 VisionImage로 변환
    let visionImage = VisionImage(image: image)
        
    //image에서 text추출
    textRecognizer.process(visionImage) { result, error in
        guard
            error == nil,
            let result = result,
            !result.text.isEmpty
            else {
                callback("", [])
                return
            }
        //text의 모든 값들을 균일화
        var scaledElements: [ScaledElement] = []
        for block in result.blocks {
            for line in block.lines {
                for element in line.elements {
                    let frame = self.createScaledFrame(
                        featureFrame: element.frame,
                        imageSize: image.size,
                        viewFrame: imageView.frame)
                    let scaledElement = ScaledElement(frame: frame)
                    scaledElements.append(scaledElement)
                }
            }
        }
            
        callback(result.text, scaledElements)
    }
}
    
   // input image, ImageView, output text를 규격화
    private func createScaledFrame(
        featureFrame: CGRect,
        imageSize: CGSize, viewFrame: CGRect)
        -> CGRect {
            //storyborad의 imageView크기
            let viewSize = viewFrame.size
            //input사진과 imageView의 비율
            let resolutionView = viewSize.width / viewSize.height
            let resolutionImage = imageSize.width / imageSize.height
            //??
            var scale: CGFloat
            if resolutionView > resolutionImage {
                scale = viewSize.height / imageSize.height
            } else {
                scale = viewSize.width / imageSize.width
            }
            //출력할 정보틀을 규격화
            let featureWidthScaled = featureFrame.size.width * scale
            let featureHeightScaled = featureFrame.size.height * scale
            //input image 규격화
            let imageWidthScaled = imageSize.width * scale
            let imageHeightScaled = imageSize.height * scale
            let imagePointXScaled = (viewSize.width - imageWidthScaled) / 2
            let imagePointYScaled = (viewSize.height - imageHeightScaled) / 2
            //출력할 정보를 규격화
            let featurePointXScaled = imagePointXScaled + featureFrame.origin.x * scale
            let featurePointYScaled = imagePointYScaled + featureFrame.origin.y * scale
            
            return CGRect(x: featurePointXScaled,
                          y: featurePointYScaled,
                          width: featureWidthScaled,
                          height: featureHeightScaled)
    }
    
}
