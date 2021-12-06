import UIKit
import Alamofire

class LectureViewController: UIViewController {
    var imageData: UploadData?
    var lectureData: LectureData?
    var templateID: String = "template01-01"
    var languageType: String?
    var titleFont = "bold"
    var bodyFont = "bold"
    
    
    @IBOutlet weak var materialNameTextField: UITextField!
    @IBOutlet weak var progressBarImageView: UIImageView!
    @IBOutlet weak var languageTypeButton: UIButton!
    @IBOutlet weak var templateTypeButton: UIButton!
    @IBAction func languageTypeButtonTouched(_ sender: Any) {
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "font" {
//            let viewController: FontViewController = segue.destination as! FontViewController
////            viewController.delegate = self
//        }
//    }
    
    private func configure() {
        materialNameTextField.delegate = self
        progressBarImageView.addShadowToUnder()
        materialNameTextField.addLeftPadding()
        
        let english = UIAction(title: "영어", handler: { _ in self.languageType = "eng" })
        let korean = UIAction(title: "한글", handler: { _ in self.languageType = "kor" })
        languageTypeButton.menu = UIMenu(children: [english,
                                                   korean])
        templateTypeButton.titleLabel?.text = templateID
    }
    
    @IBAction func createButtonTouched(_ sender: Any) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        var materialName = ""
        if materialNameTextField.text == "" {
            materialName = "sample.pptx"
        } else {
            materialName = materialNameTextField.text! + ".pptx"
        }
        
        UserDefaults.standard.set(materialName, forKey: "materialName")
//        let templateID = templateTypeButton.currentTitle ?? "template01-01"
        let templateID = "template04-01"
        let lectureData = Lecture.make(imageData: imageData!, materialName: materialName, templateID: templateID, fontSize: 12, fontType: "CookieRun Bold")
        print(lectureData)
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


extension LectureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
