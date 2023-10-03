//
//  ViewController.swift
//  AKampus
//
//  Created by İsmail Nermiş on 3.10.2023.
//

import UIKit
import PhotosUI
import MLKit

class Homepage: UIViewController {
    
    @IBOutlet weak var labelMessage: UILabel!
    
    var userPoints = 0
    let textRecognizer = TextRecognizer.textRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelMessage.alpha = 0
        
    }
    // MARK: - Camera Button
    @IBAction func buttonCamera(_ sender: UIButton) {
        labelMessage.alpha = 0
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    // MARK: - Gallery Button
    @IBAction func buttonGallery(_ sender: Any) {
        labelMessage.alpha = 0
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Recognize Text Func
    func recognizeText(image: UIImage?){
        if let image = image {
            let visionImage = VisionImage(image: image)
            visionImage.orientation = image.imageOrientation
            textRecognizer.process(visionImage) { result, error in
                guard error == nil, let result = result else {
                    print("Metin tanıma başarısız : \(error?.localizedDescription ?? "Bilinmeyen Hata")")
                    return
                }
                
                let resultText = result.text
                for block in result.blocks {
                    let blockText = block.text
                    let blockLanguages = block.recognizedLanguages
                    let blockCornerPoints = block.cornerPoints
                    let blockFrame = block.frame
                    for line in block.lines {
                        let lineText = line.text
                        let lineLanguages = line.recognizedLanguages
                        let lineCornerPoints = line.cornerPoints
                        let lineFrame = line.frame
                        for element in line.elements {
                            let elementText = element.text
                            let elementCornerPoints = element.cornerPoints
                            let elementFrame = element.frame
                        }
                    }
                }
                DispatchQueue.main.async {
                    print(resultText)
                    let recognizedText = resultText.lowercased()
                    if recognizedText.contains("fatura"){
                        self.labelMessage.alpha = 1
                        self.userPoints += 10
                        print("User Points : \(self.userPoints)")
                    }else{
                        let alert = UIAlertController(title: "Bulunamadı!", message: "Faturada Pantene bulunamadı.", preferredStyle: .alert)
                        let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
                        alert.addAction(iptalAction)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
}

// MARK: - Extension : UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension Homepage : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - ImagePicker Func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recognizeText(image: userPickedImage)
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - Extension : PHPickerViewControllerDelegate
extension Homepage : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let _ = results.first?.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
            if let image = image as? UIImage {
                self.recognizeText(image: image)
            }
        }
    }
}
