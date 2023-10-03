//
//  ViewController.swift
//  AKampus
//
//  Created by İsmail Nermiş on 3.10.2023.
//

import UIKit

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
        
    }
    
    
}

// MARK: - Extension : UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension Homepage : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - ImagePicker Func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Success")
        }
        picker.dismiss(animated: true)
    }
}
