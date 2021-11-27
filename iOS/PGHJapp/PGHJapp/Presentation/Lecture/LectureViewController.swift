import UIKit
import Alamofire

class LectureViewController: UIViewController, SendDataDelegate {
    var myData: UploadData?
    var lectureData: LectureData?
    var templateID = "template01-01"
    var titleFont = "bold"
    var bodyFont = "bold"
    
    @IBOutlet weak var materialNameTextField: UITextField!
    @IBOutlet weak var progressBarImageView: UIImageView!
    @IBOutlet weak var languageTypeButton: UIButton!
    @IBOutlet weak var templateTypeButton: UIButton!
    @IBAction func languageTypeButtonTouched(_ sender: Any) {
        
    }
    
    func sendData(data: UploadData) {
        myData = data
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
//        lectureData = Lecture.make(imageData: myData!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "font" {
            let viewController: FontViewController = segue.destination as! FontViewController
            viewController.delegate = self
        }
    }
    
    private func configure() {
        progressBarImageView.addShadowToUnder()
        materialNameTextField.addLeftPadding()
        
        let english = UIAction(title: "영어", handler: { _ in print("영어") })
        let korean = UIAction(title: "한글", handler: { _ in print("한글 ") })
        languageTypeButton.menu = UIMenu(children: [english,
                                                   korean])
        templateTypeButton.titleLabel?.text = templateID
    }
    
    @IBAction func createButtonTouched(_ sender: Any) {
        print(myData)
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.request(Endpoint.createRequest, method: .post, parameters: lectureData, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)"])
            .responseDecodable(of: Material.self) { response in
                print(response)
                switch response.result {
                case .success(let material):
                    guard let downloadVC = self.storyboard?.instantiateViewController(withIdentifier: "DownloadViewController") as? DownloadViewController else { return }
                    downloadVC.material = material
                    self.navigationController?.pushViewController(downloadVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension LectureViewController: FontViewControllerDelegate {
    func sendData(titleFont: String, bodyFont: String) {
        self.titleFont = titleFont
        self.bodyFont = bodyFont
    }
}
