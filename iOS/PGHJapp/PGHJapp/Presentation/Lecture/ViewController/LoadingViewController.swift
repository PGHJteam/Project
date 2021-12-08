//
//  LoadingViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/11.
//

import UIKit
import Alamofire
import GoogleMobileAds

class LoadingViewController: UIViewController {
    var images: [UIImage]?
    var languageType: String?
    var adLoader: GADAdLoader!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressBarImageView: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        progressBarImageView.addShadowToUnder()
        activityIndicator.startAnimating()
        uploadImages()
        configureBannerView()
    }
    
    private func uploadImages() {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(self.languageType!.utf8), withName: "image_type")
            if let images = self.images {
                for (index, image) in images.enumerated() {
                    let imageData = image.pngData()!
                    print(imageData)
                    multipartFormData.append(imageData, withName: "image\(index)", fileName: "image\(index).png")}
            }
        }, to: Endpoint.uploadImage, method: .post, headers: ["Authorization": "Bearer \(token)"]) {$0.timeoutInterval = 900}
            .responseDecodable(of: UploadData.self) { response in
                switch response.result {
                case .success(let imageData):
                    guard let loadingSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "LoadingSuccessViewController") as? LoadingSuccessViewController else { return }
                    loadingSuccessVC.imageData = imageData

                    self.navigationController?.pushViewController(loadingSuccessVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        // request 중지
    }
}

extension LoadingViewController: GADBannerViewDelegate {
//    alert창을 띄워야 리젝이 안된다는 이야기가 있다. https://nsios.tistory.com/116
    private func configureBannerView() {
        bannerView.adUnitID = "ca-app-pub-5273303934305782/6840111681"
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test ad mode
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
}
