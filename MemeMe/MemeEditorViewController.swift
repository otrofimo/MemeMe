//
//  ViewController.swift
//  MemeMe
//
//  Created by Oleg Trofimov on 7/26/15.
//  Copyright (c) 2015 Oleg Trofimov. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    let topTextDefault = "TOP"
    let bottomTextDefault = "BOTTOM"

    // Lower bar options
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UINavigationItem!

    @IBOutlet weak var topTextfield: UITextField! {
        didSet {
            topTextfield.defaultTextAttributes = memeTextAttributes
            topTextfield.text = topTextDefault
            topTextfield.textAlignment = .Center
            topTextfield.delegate = self
        }
    }
    @IBOutlet weak var bottomTextfield: UITextField! {
        didSet {
            bottomTextfield.defaultTextAttributes = memeTextAttributes
            bottomTextfield.text = bottomTextDefault
            bottomTextfield.textAlignment = .Center
            bottomTextfield.delegate = self
        }
    }

    // Default attributes for text field
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : Float(-3)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Disable camera button in simulator
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        // Subscribe to keyboard show/hide notifications
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

    // Adds observers for showing and hiding of keyboard
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
        case topTextDefault, bottomTextDefault:
            textField.text = ""
        default:
            break
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        // if textfield is empty change text to be default
        switch textField {
        case topTextfield:
            if (topTextfield.text == "") {topTextfield.text = topTextDefault}
        case bottomTextfield:
            if (bottomTextfield.text == "") {bottomTextfield.text = bottomTextDefault}
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

    @IBAction func cancelEditing(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func shareMeme(sender: UIBarButtonItem) {
        if let image = self.imageView.image {
            var memedImage = generateMemedImage(image)
            let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: { self.save() })
        }
    }

    func save() {
        if let image = self.imageView.image {
            var memedImage = generateMemedImage(image)
            var meme = Meme(image: image, memedImage: memedImage, topText: topTextfield.text, bottomText: bottomTextfield.text)
            // Add it to the memes array in the Application Delegate
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func generateMemedImage(image: UIImage) -> UIImage {

        // Hide navigation bars
        setNavigationBarsToHidden(true)

        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Show navigation bars
        setNavigationBarsToHidden(false)

        return memedImage
    }
    
    func setNavigationBarsToHidden(hidden: Bool) -> Void {
        // Toggle top toolbar vibility
        self.navigationController?.setNavigationBarHidden(hidden, animated: true)
        
        // Toggle bottom toolbar visibility
        self.bottomToolbar.hidden = hidden
    }
    
}

