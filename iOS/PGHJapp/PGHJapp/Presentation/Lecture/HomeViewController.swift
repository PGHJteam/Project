import UIKit
import PhotosUI
import Alamofire

class HomeViewController: UIViewController {
    private var images = [UIImage]()
    private var languageType: String = "eng-ocr"
    @IBOutlet weak var languageTypeButton: UIButton!
    @IBOutlet weak var progressBarImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
//        let orientation = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(orientation, forKey: "orientation")
//        UINavigationController.attemptRotationToDeviceOrientation()
    }

    private func configure(){
        progressBarImageView.addShadowToUnder()
        
//        let titleView = UIView()
//        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
//        logoImageView.image = UIImage(named: "LogoIcon.png")
//        logoImageView.contentMode = .scaleAspectFit
//        let logoLabel = UILabel()
//        logoLabel.text = "자료메이커 홈"
//        
//        titleView.addSubview(logoLabel)
//        titleView.addSubview(logoImageView)
//        navigationItem.titleView = titleView
        navigationItem.title = "자료메이커 홈"
        progressButton.addShadowToUnder()
        collectionView.register(UINib(nibName: "ImageCell", bundle: .main), forCellWithReuseIdentifier: "ImageCell")
        configureLayout()
        let eng_ocr = UIAction(title: "영어 인쇄체", handler: { _ in self.languageType = "eng-ocr" })
        let eng_htr = UIAction(title: "영어 필기체", handler: { _ in self.languageType = "eng-htr" })
        let kor_ocr = UIAction(title: "한글 인쇄체", handler: { _ in self.languageType = "kor-ocr" })
        let kor_htr = UIAction(title: "한글 필기체", handler: { _ in self.languageType = "kor-htr" })
        languageTypeButton.menu = UIMenu(children: [eng_ocr,eng_htr,
                                                    kor_ocr, kor_htr])
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
        loadingVC.languageType = languageType
        self.navigationController?.pushViewController(loadingVC, animated: true)
    }
    
    private func configureLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        flowLayout.itemSize = CGSize(width: (width/4)*1.1 , height: height / 5)
        self.collectionView.collectionViewLayout = flowLayout
    }
}

extension HomeViewController: PHPickerViewControllerDelegate {
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
        print("리로드")
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.id, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        let image = images[indexPath.row]
        cell.configure(image: image)
        return cell
    }
}

    

