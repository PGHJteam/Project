import UIKit
import Alamofire

class LectureViewController: UIViewController, SendDataDelegate {
    var myData: UploadData?
    var lectureData: LectureData?
    var templateID = "template01-01"
    var titleFont = "bold"
    var bodyFont = "bold"
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var languageTypeButton: UIButton!
    @IBOutlet weak var templateTypeButton: UIButton!
    @IBOutlet weak var fontTypeButton: UIButton!
    @IBAction func languageTypeButtonTouched(_ sender: Any) {
        
    }
    
    func sendData(data: UploadData) {
        myData = data
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        lectureData = Lecture.make(imageData: myData!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "font" {
            let viewController: FontViewController = segue.destination as! FontViewController
            viewController.delegate = self
        }
    }
    
    private func configure() {
        createButton.layer.cornerRadius = 5

        let englishPrinting = UIAction(title: "영어 인쇄체", handler: { _ in print("영어 인쇄체") })
        let englishHandwritting = UIAction(title: "영어 필기체", handler: { _ in print("영어 필기체") })
        let koreanPrinting = UIAction(title: "한글 인쇄체", handler: { _ in print("한글 인쇄체") })
        let koreanHandwritting = UIAction(title: "한글 필기체", handler: { _ in print("한글 필기체") })
        let mathPrinting = UIAction(title: "수식 인쇄체", handler: { _ in print("수식 인쇄체") })
        let mathHandwriting = UIAction(title: "수식 필기체", handler: { _ in print("수식 필기체") })

        languageTypeButton.menu = UIMenu(children: [englishPrinting, englishHandwritting,
                                                   koreanPrinting, koreanHandwritting,
                                                   mathPrinting, mathHandwriting])
        templateTypeButton.titleLabel?.text = templateID
    }
    
    @IBAction func createButtonTouched(_ sender: Any) {
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
