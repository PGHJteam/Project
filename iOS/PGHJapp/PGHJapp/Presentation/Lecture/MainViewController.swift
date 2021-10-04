import UIKit
import PhotosUI
import Alamofire

class MainViewController: UIViewController, PHPickerViewControllerDelegate {
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
        imageCount.text = "\(results.count)"
    }


    private var images = [UIImage]()
    @IBOutlet weak var imageCount: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var createButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
        
        if let imageData = image.pngData() {
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Data("english".utf8), withName: "image_type")
                multipartFormData.append(imageData, withName: "imageFile", fileName: "image\(index)")
            }, to: "/api/files/upload/images/", method: .post, headers: ["Authorization": UserDefaults.standard.string(forKey: "accessToken") ?? ""])
            .responseJSON { response in
                print(response) // 처리해주기
            }
//
//        }
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(Data("english".utf8), withName: "image_type")
//        }, to: URL(string: "https://8feaee36-6bec-4c60-a418-69f2bff63701.mock.pstmn.io/api/files/upload/images/")!)
//            .responseJSON { response in
//                dump(response)
//            }
        }
    }

    @IBAction func createButtonTouched(_ sender: Any) {
        dump(images)
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data("english".utf8), withName: "image_type")
            for (index, image) in self.images.enumerated() {
                let imageData = image.pngData()!
                multipartFormData.append(imageData, withName: "imageFile", fileName: "image\(index)")
            }}, to: "http://13.125.157.223:8000/api/files/upload/images/", method: .post, headers: ["Authorization": "Bearer \(token)"])
            .responseJSON { response in
                print(response) // 처리해주기
                
            }
    }
}

//extension MainViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//
//        results.forEach { item in
//            let itemProvider = item.itemProvider
//            if itemProvider.canLoadObject(ofClass: UIImage.self) {
//                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
//                    if let myImage = image as? UIImage {
//                        self.images.append(myImage)
//                    }
//                }
//            }
//        }
//        imageCount.text = "\(results.count)"
//        let itemProvider = results.last?.itemProvider

//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
//                DispatchQueue.main.async {
//                    self.myImageView.image = image as? UIImage
//                }
//            }
//
//        } else {
//            // error 처리
//        }
    
    
    

