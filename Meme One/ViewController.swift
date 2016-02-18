//
//  ViewController.swift
//  Meme One
//
//  Created by TY on 2/11/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var blueSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var topToolBar: UIToolbar!
    @IBOutlet var bottomToolBar: UIToolbar!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var imagePicker: UIBarButtonItem!
    @IBOutlet var actionButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: Float(-1)
    ]
    
    override func viewDidLoad() {
        
        self.redSlider.thumbTintColor = UIColor.clearColor()
        self.greenSlider.thumbTintColor = UIColor.clearColor()
        self.blueSlider.thumbTintColor = UIColor.clearColor()
        
        super.viewDidLoad()
        topTextField.delegate = self
        topTextField.textAlignment = .Center
        topTextField.backgroundColor = UIColor.clearColor()
        topTextField.defaultTextAttributes = memeTextAttributes

        bottomTextField.delegate = self
        bottomTextField.textAlignment = .Center
        bottomTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.defaultTextAttributes = memeTextAttributes
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        placeholderText()
        imagePicker.enabled  = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribetoKeyBoardNotifs()
        self.unsubscribeToKeyBoardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillShowNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        if bottomTextField.text! == ""{
            dispatch_async(dispatch_get_main_queue(),{
                self.performAnimation()
            })
        }else{
            placeholderText()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.endEditing(true)
        self.unsubscribeToKeyBoardNotifications()
        self.view.frame.origin.y = 0
        return true
    }
    
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y -=  getKeyBoardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y += getKeyBoardHeight(notification)
        }
    }
    
    func subscribetoKeyBoardNotifs(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyBoardNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func pickImage(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
        
    
    }
    @IBAction func pickCameraImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imagePickerView.image = image
            imagePickerView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func placeholderText(){
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "ENTER TOP...", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "ENTER BOTTOM...", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }
    
    func removeMemeObjects(){
        
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        redSlider.hidden = true
        greenSlider.hidden = true
        blueSlider.hidden = true
    }
    
    func addMemeObjects(){
        
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        redSlider.hidden = false
        greenSlider.hidden = false
        blueSlider.hidden = false
    
    }
    
    @IBAction func setMemeTextColor(sender: AnyObject){
        let r = CGFloat(redSlider.value)
        let g = CGFloat(greenSlider.value)
        let b = CGFloat(blueSlider.value)
    
        topTextField.textColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        bottomTextField.textColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    func performAnimation(){
        UIView.animateWithDuration(1, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.redSlider.thumbTintColor = UIColor.lightGrayColor()
            self.greenSlider.thumbTintColor = UIColor.lightGrayColor()
            self.blueSlider.thumbTintColor = UIColor.lightGrayColor()
            },completion: nil)
    }
    
    func generateMemedImage() -> UIImage{
        removeMemeObjects()
        //Render entire view to one image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        addMemeObjects()
    
            return memedImage
    }
    
    func save() {
        //Create the meme
        _ = Meme( topText:topTextField.text!, bottomText: bottomTextField.text!, image:imagePickerView.image!, memedImage:generateMemedImage())
    }
    
    @IBAction func shareMemeActivity(sender: AnyObject) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {activity, success, items, error in
            if success{
                self.save()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
        print("\(generateMemedImage()) was sent!")
    }
    
    @IBAction func cancelMemeButton(sender: AnyObject) {
        cancelButton.enabled = true
        imagePickerView.image = nil
        topTextField.text = ""
        bottomTextField.text = ""
        placeholderText()
        self.unsubscribeToKeyBoardNotifications()
    }
}

