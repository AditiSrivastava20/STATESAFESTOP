//
//  ImagePickViewController.swift
//  SSS
//
//  Created by Sierra 4 on 23/03/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

class ImagePickViewController: UIViewController {
    
    var selectedImage: UIImage? = nil
    var pickImageDelegate: DataSentDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnClearAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGalleryAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCameraAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}



//MARK:-  imagePickerControllerDelegates
extension ImagePickViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if pickImageDelegate != nil {
            if selectedImage != nil {
                pickImageDelegate?.userProfilePicInput(image: selectedImage!)
            }
        }
        
        dismiss(animated: true) {
            self.btnClearAction(Any.self)
        }
    }
}



//MARK:- custom delegate to send data back to previous viewcontroller
protocol DataSentDelegate {
    
    func userProfilePicInput(image: UIImage)
    
}
