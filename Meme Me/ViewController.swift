//
//  ViewController.swift
//  Meme Me
//
//  Created by Paul Gaudin on 11/20/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!

    
    var memes: [Meme]!
    
    var originalBottomSpacing:CGFloat?
    

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "Helvetica-bold", size: 37)!,
        NSStrokeWidthAttributeName : -3.0,
        NSForegroundColorAttributeName : UIColor.whiteColor()
    ]

    @IBAction func takePhoto(sender: AnyObject) {
        
        getPhoto(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func choosePhoto(sender: AnyObject) {
        print("can you hear me git?")
        getPhoto(UIImagePickerControllerSourceType.PhotoLibrary)

   }
    
    func getPhoto(source: UIImagePickerControllerSourceType){
    
        imagePicker.delegate = self
        
        imagePicker.sourceType = source
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let imageChosen = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.image.image = imageChosen
            self.image.contentMode = UIViewContentMode.ScaleAspectFit
        }else{
            print("errorrrrrr")
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(image.frame.size)

        let context = UIGraphicsGetCurrentContext()
        
        image.layer.renderInContext(context!)
        
        CGContextTranslateCTM(context, 0.0, topText.frame.minY - image.frame.minY)
        
        topText.layer.renderInContext(context!)
        
        CGContextTranslateCTM(context, 0.0, image.frame.height - bottomText.frame.height - bottomSpacing.constant - (topText.frame.minY - image.frame.minY))
        
        bottomText.layer.renderInContext(context!)

        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func save() {
        
        let memedImage = generateMemedImage()
        let meme = Meme( topText: topText.text!, bottomText: bottomText.text!, image: image.image!, memedImage: memedImage)
        
        memes.append(meme)
        
        let activityViewController = UIActivityViewController(activityItems:[memedImage] , applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        if topText.text != nil && bottomText.text != nil && image.image != nil{
        
            save()

        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)


        topText.defaultTextAttributes = memeTextAttributes
                        topText.textColor = UIColor.whiteColor()
        topText.textAlignment = .Center

            bottomText.textColor = UIColor.whiteColor()
        bottomText.defaultTextAttributes = memeTextAttributes
        
        bottomText.textAlignment = .Center


        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        bottomSpacing.constant += getKeyboardHeight(notification) - originalBottomSpacing!
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        originalBottomSpacing = bottomSpacing.constant
        self.subscribeToKeyboardNotifications()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
    }
    

    func keyboardWillHide(notification: NSNotification){
        bottomSpacing.constant = originalBottomSpacing!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

