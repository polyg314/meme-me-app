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
    
    @IBOutlet weak var bottomTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var bottomLeading: NSLayoutConstraint!
    
    var topConstY:CGFloat?
    
    var topConstX1:CGFloat?
    
    var topConstX2:CGFloat?
    
    var memes: [Meme]!
    
    var originalBottomSpacing:CGFloat?
    
    
    var topPlacement:CGPoint?
    
    var bottomPlacement:CGPoint?
    
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
            self.image.contentMode = UIViewContentMode.ScaleAspectFit
            self.view.sendSubviewToBack(image)
            self.image.image = imageChosen
        }else{
            print("errorrrrrr")
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func editTopBegin(sender: AnyObject) {
        topText.clearsOnBeginEditing = false
    }
    
    
    @IBAction func editBottomBegin(sender: AnyObject) {
        bottomText.clearsOnBeginEditing = false
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

        print(topConstY)
        
        print(topConstX1)
        
    }

    
    func userDraggedBottom(gesture: UIPanGestureRecognizer){
        var loc = gesture.locationInView(self.view)
        
        self.bottomText.center = loc
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topText.clearsOnBeginEditing = true
        bottomText.clearsOnBeginEditing = true
        
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
        print(topPlacement)
        print(bottomPlacement)

        
        originalBottomSpacing = bottomSpacing.constant
        self.subscribeToKeyboardNotifications()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        

        
    }
    
    override func viewDidAppear(animated: Bool) {

//        print(topConstY)
//        
//        print(topConstX1)
//        
//        if var topConstY = topConstY {
//            
//            topTextYConstraint.constant = topConstY
//        
//        }
//        
//        if var topConstX1 = topConstX1{
//        
//            topTextXContraint.constant = topConstX1
//        
//        }
//        
//        if var topConstX2 = topConstX2 {
//        
//            topTextX2Constraint.constant = topConstX2
//        
//        }
        
//        
//        
//        if var bottomPlacement = bottomPlacement{
//            
//            print("heyyy just do it")
//
//        }
//        
//        if var topPlacement = topPlacement{
//            
//            print("really tho")
//            self.topText.center = topPlacement
//            
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        topTextYConstraint.constant = topText.frame.minY - image.frame.minY
        
        topTextXContraint.constant = topText.frame.minX - image.frame.minX

        topTextX2Constraint.constant = topText.frame.minX - image.frame.minX
//        
//        topConstY = topTextYConstraint.constant
//        
//        topConstX1 = topTextXContraint.constant
//        
//        topConstX2 = topTextX2Constraint.constant
        

        bottomSpacing.constant = image.frame.maxY - bottomText.frame.maxY
        
        bottomLeading.constant = bottomText.frame.minX - image.frame.minX
       
         bottomTrailing.constant = bottomText.frame.minX - image.frame.minX

        print("disappear")
        
    }

    func keyboardWillHide(notification: NSNotification){
        
        bottomSpacing.constant = originalBottomSpacing!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

