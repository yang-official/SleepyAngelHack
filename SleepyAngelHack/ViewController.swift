//
//  ViewController.swift
//  SleepyAngelHack
//
//  Created by gawawa124 on 2017/05/06.
//  Copyright © 2017年 gawawa124. All rights reserved.
//

import UIKit
import AWSCore
import AWSRekognition

class ViewController: UIViewController {

    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sleepingIcon: UIImageView!
    @IBOutlet weak var sleepingScore: UILabel!
    @IBOutlet weak var hotelView: UIView!
    
    var isFirstTime: Bool = false
    
    var rekognitionClient: AWSRekognition!
    
    let collectionName = "trial2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rekognitionClient = AWSRekognition.default()
        showRecommendView(sleepingScore: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstTime == false {
            isFirstTime = true
            
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showRecommendView(sleepingScore: Double) {
        let tuple = ColorCalculator.calculate(score: sleepingScore)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.messageLabel.text = tuple.message
            self.sleepingScore.text = String(Int(sleepingScore))
            
            if sleepingScore < 48 {
                //green
                self.recommendViewHeightConstraint.constant = 100
                
            } else {
                if sleepingScore <= 82 {
                    //yellow
                    self.recommendViewHeightConstraint.constant = 400
                } else {
                    //red
                    self.recommendViewHeightConstraint.constant = 400
                }
            }
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.recommendView.backgroundColor = tuple.bgColor
                
                if sleepingScore < 48 {
                    //green
                    self.sleepingIcon.isHidden = true
                    self.sleepingIcon.image = tuple.icon
                    self.hotelView.isHidden = true
                    
                } else {
                    self.sleepingIcon.isHidden = false
                    self.sleepingIcon.image = tuple.icon
                    self.hotelView.isHidden = false
                }
            })
        }
    }
    
    func createCollection(faceImage: UIImage) {
        guard let request = AWSRekognitionCreateCollectionRequest() else{
            print("Unable to initialize AWSRekognitionCreateCollectionRequest.")
            return
        }
        
        request.collectionId = collectionName
        rekognitionClient.createCollection(request) {
            (response: AWSRekognitionCreateCollectionResponse?, error: Error?) in
            if error == nil {
                self.detect(faceImage: faceImage)
            } else {
                print(error ?? "error")
            }
        }
    }
    
    func detect(faceImage: UIImage) {
        let image = AWSRekognitionImage()
        image!.bytes = UIImageJPEGRepresentation(faceImage, 0.7)
        
        guard let request = AWSRekognitionIndexFacesRequest() else {
            print("Unable to initialize AWSRekognitionindexFaceRequest.")
            return
        }
        
        request.collectionId = collectionName
        request.detectionAttributes = ["ALL"]
        //        request.externalImageId = "image id"
        request.image = image
        
        rekognitionClient.indexFaces(request) {
            [weak self] (response: AWSRekognitionIndexFacesResponse?, error: Error?) in
            if error == nil {
                var sleepingScore: Double = 0
                if let eyesOpen = response?.faceRecords?[0].faceDetail?.eyesOpen,
                    let smile = response?.faceRecords?[0].faceDetail?.smile {
                    sleepingScore = EyesOpenCalculator.calculateEyesOpen(eyesOpen: eyesOpen, smile: smile)
                    print("smile: \()")
                    print("eyesOpenConfidence: \(String(describing: eyesOpen.confidence)), value: \(String(describing: eyesOpen.value))")
                    print("sleepingScore: \(sleepingScore)")
                    
                    //smile
                    // if smile == true {  - smile.confidence / 4 , eyesOpenConfidece}
                }
                
                DispatchQueue.main.async {
                    self?.showRecommendView(sleepingScore: sleepingScore)
                }
            } else {
                print(error ?? "error")
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        picker.dismiss(animated: true) {
            if UserDefaults.standard.bool(forKey: "hasCreatedCollection") == false {
                UserDefaults.standard.set(true, forKey: "hasCreatedCollection")
                UserDefaults.standard.synchronize()
                self.createCollection(faceImage: image)
            } else {
                self.detect(faceImage: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
