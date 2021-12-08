import UIKit
import Alamofire

class LectureViewController: UIViewController {

    var imageData: UploadData?
    //    var lectureData: LectureData?
    private var name: String = "sample"
    private var templateID: String = Templates.getID(number: 0)

    var titleFont = "bold"
    var bodyFont = "bold"
    
    @IBOutlet weak var materialNameTextField: UITextField!
    @IBOutlet weak var templateTypeButton: UIButton!
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var progressBarImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func configure() {
        materialNameTextField.delegate = self
        progressBarImageView.addShadowToUnder()
        materialNameTextField.addLeftPadding()
        configureTemplate()
    }
    
    private func configureTemplate() {
        templateTypeButton.setTitle(templateID, for: .normal)
        templateImageView.image = UIImage(named: templateID+".png")
    }
    
    
    @IBAction func createButtonTouched(_ sender: Any) {
        // lecture만든 뒤 넘기기
        guard let fontVC = self.storyboard?.instantiateViewController(withIdentifier: "FontViewController") as? FontViewController else { return }
        var lecture = Lecture(name: name, templateID: templateID)
        lecture.fetchImageData(imageData: imageData!, font: Font(size: 10, type: "NanumBarunGothic"))
        fontVC.lecture = lecture
        self.navigationController?.pushViewController(fontVC, animated: true)
    }
}


extension LectureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name = textField.text ?? "sample"
        UserDefaults.standard.set(name+".pptx", forKey: "materialName")
        textField.resignFirstResponder()
        return true
    }
}

extension LectureViewController: TemplateDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTemplateList" {
            guard let templateVC: TemplateViewController = segue.destination as? TemplateViewController else { return }
            templateVC.delegate = self
        }
    }
    
    func sendTemplateStyle(id: String?) {
        guard let newTemplateStyle = id else {return}
        templateID = newTemplateStyle
        configureTemplate()
    }
}
