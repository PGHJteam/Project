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
    @IBOutlet weak var uploadButton: UIButton!
    var delegate: SendDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        addButton.layer.cornerRadius = 15
        uploadButton.layer.cornerRadius = 15
    }
    
    @IBAction func addButtonTouched(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    

    @IBAction func uploadButtonTouched(_ sender: Any) {
        guard let loadingVC = self.storyboard?.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController else { return }
        loadingVC.images = images
        self.navigationController?.pushViewController(loadingVC, animated: true)
//        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(Data("eng-htr".utf8), withName: "image_type")
//
//            for (index, image) in self.images.enumerated() {
//                let imageData = image.pngData()!
//                print(imageData)
//                multipartFormData.append(imageData, withName: "image\(index)", fileName: "image\(index).png")}
//        }, to: Endpoint.uploadImage, method: .post, headers: ["Authorization": "Bearer \(token)"])
//            .responseDecodable(of: UploadData.self) { response in
//                print(response)
//                switch response.result {
//                case .success(let imageData):
//                    guard let lectureVC = self.storyboard?.instantiateViewController(withIdentifier: "LectureViewController") as? LectureViewController else { return }
//                    lectureVC.myData = imageData
//                    self.delegate?.sendData(data: imageData)
//
//                    self.navigationController?.pushViewController(lectureVC, animated: true)
//                case .failure(let error):
//                    print(error)
//                }
//            }
    }
}
    

    

