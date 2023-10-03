//
//  ViewController.swift
//  AKampus
//
//  Created by İsmail Nermiş on 3.10.2023.
//

import UIKit
import PhotosUI

class Homepage: UIViewController {
    
    @IBOutlet weak var labelMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelMessage.alpha = 0
        
    }
    // MARK: - Camera Button
    @IBAction func buttonCamera(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true)
    }
    
    // MARK: - Gallery Button
    @IBAction func buttonGallery(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

// MARK: - Extension : UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension Homepage : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - ImagePicker Func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Success Camera")
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
                print("Success Gallery")
            }
        }
    }
}
