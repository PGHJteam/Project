import UIKit
import PhotosUI
import Alamofire

class ViewController: UIViewController {

    private var images = [UIImage]()
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
//    @IBOutlet weak var progressView: UIProgressView!
//    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let test = Temp(template_id: 0, items: [Item(text: "hello world", coordinates: Coordinates(x: 100, y: 100)),Item(text: "hello world", coordinates: Coordinates(x: 100, y: 100))])
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(test)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            print(jsonString) //{"name":"Zedd","age":100}
        }
    }
    
    func configure(){
        addButton.layer.cornerRadius = 15
        createButton.layer.cornerRadius = 15
    }
    
    @IBAction func addButtonTouched(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func upload(image: UIImage, index: Int, progressCompletion: @escaping (_ percent: Float) -> Void, completion: @escaping (_ result: Bool) -> Void) {
        
        
        
//        if let imageData = image.pngData() {
//            AF.upload(multipartFormData: { multipartFormData in
//                multipartFormData.append(imageData, withName: "imageFile", fileName: "image\(index)")
//            }, to: APIRouter.uploadImage, method: .post
//            headers: ["Authorization": "Basic\(authorization)"],
//            )
//            .responseJSON { response in
//                print(response) // 처리해주기
//            }
//
//        }
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(Data("english".utf8), withName: "image_type")
//        }, to: URL(string: "https://8feaee36-6bec-4c60-a418-69f2bff63701.mock.pstmn.io/")!)
//            .responseJSON { response in
//                dump(response)
//            }
    }

    @IBAction func createButtonTouched(_ sender: Any) {
//        progressView.progress = 0.0
//        progressView.isHidden = false
//        activityIndicatorView.startAnimating()
//        dump(images)
//
//        for (index, image) in images.enumerated() {
//            upload(image: image, index: index) { [weak self] percent in
//                guard let strongSelf = self else {return}
//                strongSelf.progressView.setProgress(percent, animated: true)
//            } completion: { [weak self] result in
//                guard let strongSelf = self else {return}
//                strongSelf.progressView.isHidden = true
//                strongSelf.activityIndicatorView.stopAnimating()
//                strongSelf.images = []
//                strongSelf.myImageView.image = nil
//            }
//
//        }
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        results.forEach { item in
            let itemProvider = item.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let myImage = image as? UIImage {
                        self.images.append(myImage)
                    }
                }
            }
        }
        let itemProvider = results.last?.itemProvider

        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.myImageView.image = image as? UIImage
                }
            }

        } else {
            // error 처리
        }
    }
    
    
}
