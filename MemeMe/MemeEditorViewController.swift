//
//  ViewController.swift
//  MemeMe
//
//  Created by Oleg Trofimov on 7/26/15.
//  Copyright (c) 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    @IBOutlet weak var topTextfield: UITextField! {
        didSet {
            topTextfield.text = "TOP"
            topTextfield.textAlignment = .Center
            topTextfield.defaultTextAttributes = memeTextAttributes
            topTextfield.delegate = self
        }
    }
    
    @IBOutlet weak var bottomTextfield: UITextField! {
        didSet {
            bottomTextfield.text = "BOTTOM"
            bottomTextfield.textAlignment = .Center
            bottomTextfield.defaultTextAttributes = memeTextAttributes
            bottomTextfield.delegate = self
        }
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-3)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    // If the text is the default text, remove before editing
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField.text{
        case "TOP", "BOTTOM":
            textField.text = ""
        default:
            break
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickImage(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePicture(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

