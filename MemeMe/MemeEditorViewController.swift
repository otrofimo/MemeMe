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

    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-3)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.text = "TOP"
        topTextfield.textAlignment = .Center
        topTextfield.delegate = self

        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.text = "BOTTOM"
        bottomTextfield.textAlignment = .Center
        bottomTextfield.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() {
          self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomTextfield.isFirstResponder() {
            self.view.frame.origin.y += getKeyBoardHeight(notification)
        }
    }

    func getKeyBoardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        var keyboardSize: NSValue?
        
        println("is equal to show notification?")
        println(notification.name == UIKeyboardWillShowNotification)
        
        switch notification.name {
        case UIKeyboardWillShowNotification:
           keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue
        case UIKeyboardWillHideNotification:
           keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue
        default:
            println("Correct notifications not found")
        }

        return keyboardSize!.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
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

