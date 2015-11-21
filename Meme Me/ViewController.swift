//
//  ViewController.swift
//  Meme Me
//
//  Created by Paul Gaudin on 11/20/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
    
    var topDrag = false

    var startLocation:CGPoint!
    
    var endLocation:CGPoint!
    
    var topYOriginal:CGFloat?
    
    var topXOriginal1:CGFloat?
    
    var topXOriginal2:CGFloat?
    
    var topChangeX:CGFloat?
    
    var topChangeY:CGFloat?

    
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
        
        
        print(bottomText.frame)
        
        print(image.frame)
        
        UIGraphicsBeginImageContext(image.frame.size)

        let context = UIGraphicsGetCurrentContext()
        
        image.layer.renderInContext(context!)
        
        CGContextTranslateCTM(context, topText.frame.minX - image.frame.minX, topText.frame.minY - image.frame.minY)
        
        topText.layer.renderInContext(context!)
        
        CGContextTranslateCTM(context, bottomText.frame.minX - image.frame.minX - (topText.frame.minX - image.frame.minX), bottomText.frame.minY - image.frame.minY - (topText.frame.minY - image.frame.minY))
        
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
    
    
    @IBOutlet weak var topTextYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topTextXContraint: NSLayoutConstraint!
    
    @IBOutlet weak var topTextX2Constraint: NSLayoutConstraint!
    

    

    @IBAction func bottomEditEnded(sender: AnyObject) {
        
        
//        print("waddup")
//        
//        bottomSpacing.constant = originalBottomSpacing!
        
        
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        if topText.text != nil && bottomText.text != nil && image.image != nil{
        
            save()

        }
        
    }
    
    func userDraggedTop(gesture: UIPanGestureRecognizer){
        var loc = gesture.locationInView(self.view)
        
        self.topText.center = loc
        
    }

    
    func userDraggedBottom(gesture: UIPanGestureRecognizer){
        var loc = gesture.locationInView(self.view)
        
        self.bottomText.center = loc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var gestureTop = UIPanGestureRecognizer(target: self, action: Selector("userDraggedTop:"))
        
        var gestureBottom = UIPanGestureRecognizer(target: self, action: Selector("userDraggedBottom:"))
        
        bottomText.addGestureRecognizer(gestureBottom)
        bottomText.userInteractionEnabled = true
        
        topText.addGestureRecognizer(gestureTop)
        topText.userInteractionEnabled = true
        
        
        
        
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
        
        bottomSpacing.constant = getKeyboardHeight(notification) - (originalBottomSpacing!/2)
        
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

