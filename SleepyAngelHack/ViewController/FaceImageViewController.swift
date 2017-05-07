//
//  FaceImageViewController.swift
//  SleepyAngelHack
//
//  Created by gawawa124 on 2017/05/06.
//  Copyright © 2017年 gawawa124. All rights reserved.
//

import UIKit
import AWSCore
import AWSRekognition

class FaceImageViewController: UIViewController {
    
    var faceImage: UIImage?
    @IBOutlet weak var faceImageView: UIImageView!
    
    var rekognitionClient: AWSRekognition!
    
    let collectionName = "trial1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rekognitionClient = AWSRekognition.default()
        faceImageView.image = faceImage
    }
    
    @IBAction func create(_ sender: Any) {
        guard let request = AWSRekognitionCreateCollectionRequest() else{
            print("Unable to initialize AWSRekognitionCreateCollectionRequest.")
            return
        }
        
        request.collectionId = collectionName
        rekognitionClient.createCollection(request) {
            (response: AWSRekognitionCreateCollectionResponse?, error: Error?) in
            if error == nil {
                print(#function)
                print(response!)
            } else {
                print(error ?? "error")
            }
        }
    }
    
    @IBAction func detect(_ sender: Any) {
        let image = AWSRekognitionImage()
        image!.bytes = UIImageJPEGRepresentation(faceImage!, 0.7)
        
        guard let request = AWSRekognitionIndexFacesRequest() else {
            print("Unable to initialize AWSRekognitionindexFaceRequest.")
            return
        }
        
        request.collectionId = collectionName
        request.detectionAttributes = ["ALL"]
//        request.externalImageId = "image id"
        request.image = image
        
//        rekognitionClient.indexFaces(request) {
//            (response: AWSRekognitionIndexFacesResponse?, error: Error?) in
//            if error == nil {
//                var sleepPoint: Double = 0
//                if let eyesOpen = response?.faceRecords?[0].faceDetail?.eyesOpen {
//                    sleepPoint = EyesOpenCalculator.calculateEyesOpen(eyesOpen: eyesOpen)
//                    print("eyesOpenConfidence: \(String(describing: eyesOpen.confidence)), value: \(String(describing: eyesOpen.value))")
//                    print("sleepPoint: \(sleepPoint)")
//                }
//                
//                let alert = UIAlertController(
//                    title: "",
//                    message: "SleepPoint: \(String(describing: sleepPoint))",
//                    preferredStyle: .alert
//                )
//                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//                
//            } else {
//                print(error ?? "error")
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
