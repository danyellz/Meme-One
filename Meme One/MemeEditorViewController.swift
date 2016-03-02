//
//  ViewController.swift
//  Meme One
//
//  Created by TY on 2/11/16.
//  Copyright © 2016 Kinectic. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
    
    var memes: [Meme]{
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        redSlider.thumbTintColor = UIColor.clearColor()
        greenSlider.thumbTintColor = UIColor.clearColor()
        blueSlider.thumbTintColor = UIColor.clearColor()
        
        formatTextFields()
    }
    
    func formatTextFields(){
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.backgroundColor = UIColor.clearColor()
        bottomTextField.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        placeholderText()
        imagePicker.enabled  = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribetoKeyBoardNotifs()
        unsubscribeToKeyBoardNotifications()
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
        unsubscribeToKeyBoardNotifications()
        view.frame.origin.y = 0
        return true
    }
    
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder(){
            view.frame.origin.y = getKeyBoardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomTextField.isFirstResponder(){
            view.frame.origin.y = 0
        }
    }
    
    func subscribetoKeyBoardNotifs(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyBoardNotifications(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func pickImage(sender: AnyObject) {
        
        pickAnImageType(.PhotoLibrary)
    }
    
    @IBAction func pickCameraImage(sender: AnyObject) {
        pickAnImageType(.Camera)
    }
    
    func pickAnImageType(dataFrom: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = dataFrom
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        addMemeObjects()
    
            return memedImage
    }
    
    func save() {
        //Create the meme
         let meme = Meme( topText:topTextField.text!, bottomText: bottomTextField.text!, image:imagePickerView.image!, memedImage:generateMemedImage())
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func shareMemeActivity(sender: AnyObject) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {activity, success, items, error in
            if success{
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
        print("\(generateMemedImage()) was sent!")
        print (memes.count)
    }
    
    @IBAction func cancelMemeButton(sender: AnyObject) {
        cancelButton.enabled = true
        imagePickerView.image = nil
        topTextField.text = ""
        bottomTextField.text = ""
        placeholderText()
        unsubscribeToKeyBoardNotifications()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

