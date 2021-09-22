import UIKit
import PhotosUI

class ViewController: UIViewController {

    private var images = [UIImage]()
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    @IBAction func addButtonTouched(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure(){
        addButton.layer.cornerRadius = 15
        requestButton.layer.cornerRadius = 15
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
