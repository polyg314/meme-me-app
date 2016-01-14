//
//  ViewController.swift
//  Meme Me
//
//  Created by Paul Gaudin on 11/20/15.
//  Copyright © 2015 yours truly. All rights reserved.
//

import UIKit

class CreateMemeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!

    @IBOutlet weak var bottomTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var bottomLeading: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!

    @IBOutlet weak var useLibraryButton: UIBarButtonItem!
    
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topTextXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topTextX2Constraint: NSLayoutConstraint!
    
    var imagePicker = UIImagePickerController()
    
    var currentMeme:Meme?
    
    var topConstY:CGFloat?
    
    var topConstX1:CGFloat?
    
    var topConstX2:CGFloat?
    
    var bottomConstY:CGFloat?
    
    var bottomConstX1:CGFloat?
    
    var bottomConstX2:CGFloat?
    
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
        topConstY = topTextYConstraint.constant
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        if appDelegate.currentIndex == -1 { 
            getPhoto(UIImagePickerControllerSourceType.PhotoLibrary)
        }
   }
    
    func deleteMeme(){
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes.removeAtIndex(appDelegate.currentIndex)
        appDelegate.memes = memes
        performSegueWithIdentifier("toCollection", sender: nil)
    }
    
    func getPhoto(source: UIImagePickerControllerSourceType){
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let imageChosen = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image.contentMode = UIViewContentMode.ScaleAspectFit
            view.sendSubviewToBack(image)
            image.image = imageChosen
            checkEnabled()
        }else{
            checkEnabled()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func editTopBegin(sender: AnyObject) {
        topText.clearsOnBeginEditing = false
    }
    
    
    @IBAction func editBottomBegin(sender: AnyObject) {
        bottomText.clearsOnBeginEditing = false
    }
 
    func generateMemedImage() -> UIImage {
        
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
        let meme = Meme( topText: topText.text!, bottomText: bottomText.text!, image: image.image!, memedImage: memedImage, bottomSpacing: bottomSpacing, bottomTrailing: bottomTrailing, bottomLeading: bottomLeading, topTextYConstraint: topTextYConstraint, topTextXConstraint: topTextXConstraint, topTextX2Constraint: topTextX2Constraint )
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        if appDelegate.currentIndex != -1 {
            memes[appDelegate.currentIndex] = meme
        }else{
            memes.append(meme)
        }
        appDelegate.memes = memes
        performSegueWithIdentifier("toCollection", sender: nil)

    }
    
    @IBAction func saveMeme(sender: UIBarButtonItem) {
            save()        
    }
    
    func checkEnabled(){
        if topText.text != nil && bottomText.text != nil && image.image != nil{
            saveButton.enabled = true
            shareButton.enabled = true
        }else{
            saveButton.enabled = false
            shareButton.enabled = false
        }
    }
    
    
    @IBAction func topEditEnded(sender: AnyObject) {
        checkEnabled()
        if topText.text!.characters.count == 0  {
            topText.text = "TOP"
            styleTopText()
        }
        if topText.text! == "TOP"{
            topText.clearsOnBeginEditing = true
        }
    }

    @IBAction func bottomEditEnded(sender: AnyObject) {
        checkEnabled()
        if bottomText.text!.characters.count == 0 {
            bottomText.text = "BOTTOM"
            styleBottomText()
        }
        if bottomText.text! == "BOTTOM" {
           bottomText.clearsOnBeginEditing = true
        }
    }
    
    func styleTopText(){
        topText.defaultTextAttributes = memeTextAttributes
        topText.textColor = UIColor.whiteColor()
        topText.textAlignment = .Center
        
    }
    
    func styleBottomText(){
        
        bottomText.textColor = UIColor.whiteColor()
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .Center
    
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {

        if topText.text != nil && bottomText.text != nil && image.image != nil{

            let activityViewController = UIActivityViewController(activityItems:[generateMemedImage()], applicationActivities: nil)
            
            presentViewController(activityViewController, animated: true, completion: nil)
            
            save()
            

        }
        
    }
    
    func userDraggedTop(gesture: UIPanGestureRecognizer){
       
        let loc = gesture.locationInView(view)
        
        topText.center = loc
        
    }

    
    func userDraggedBottom(gesture: UIPanGestureRecognizer){
        
        let loc = gesture.locationInView(view)
        
        bottomText.center = loc
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        topText.clearsOnBeginEditing = true
        bottomText.clearsOnBeginEditing = true
        
        let gestureTop = UIPanGestureRecognizer(target: self, action: Selector("userDraggedTop:"))
        
        let gestureBottom = UIPanGestureRecognizer(target: self, action: Selector("userDraggedBottom:"))
        
        bottomText.addGestureRecognizer(gestureBottom)
        bottomText.userInteractionEnabled = true
        
        topText.addGestureRecognizer(gestureTop)
        topText.userInteractionEnabled = true
        
        styleTopText()
        
        styleBottomText()
        
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)


        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        
        originalBottomSpacing = bottomSpacing.constant
        subscribeToKeyboardNotifications()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        checkEnabled()
        
        if appDelegate.currentIndex != -1 {
            currentMeme = memes![appDelegate.currentIndex]
            image.image = currentMeme!.image
            image.contentMode = UIViewContentMode.ScaleAspectFit
            topText.text = currentMeme!.topText
            topTextYConstraint.constant = currentMeme!.topTextYConstraint.constant
            topTextXConstraint.constant = currentMeme!.topTextXConstraint.constant
            topTextX2Constraint.constant = currentMeme!.topTextX2Constraint.constant
            bottomText.text = currentMeme!.bottomText
            bottomSpacing.constant = currentMeme!.bottomSpacing.constant
            bottomLeading.constant = currentMeme!.bottomLeading.constant
            bottomTrailing.constant = currentMeme!.bottomTrailing.constant
            saveButton.title = "update"
            saveButton.enabled = true
            shareButton.enabled = true
            useLibraryButton.title = ""
            useLibraryButton.enabled = true
            takePhotoButton.enabled = false
            takePhotoButton.title = ""
            self.navigationController?.setToolbarHidden(false, animated: false)
            view.sendSubviewToBack(image)
            self.setToolbarItems(toolbarItems, animated: true)
            let item2 = UIBarButtonItem(title: "Delete", style: .Plain, target: self, action: "deleteMeme")
            self.setToolbarItems([item2], animated: false)

            
        } else{
            saveButton.title = "save"
            useLibraryButton.title = "use library"
            takePhotoButton.title = "take photo"
            takePhotoButton.enabled = true
            if !UIImagePickerController.isSourceTypeAvailable(.Camera){
               takePhotoButton.enabled = false
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        setConstraints()
        if bottomSpacing.constant < getKeyboardHeight(notification) + 50 {
                bottomSpacing.constant = getKeyboardHeight(notification) + (originalBottomSpacing!/2)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func setConstraints(){
        
        topConstY = topText.frame.minY - image.frame.minY
        topConstX1 = topText.frame.minX - image.frame.minX
        topConstX2 = topText.frame.minX - image.frame.minX
        bottomConstY = image.frame.maxY - bottomText.frame.maxY
        bottomConstX1 = bottomText.frame.minX - image.frame.minX
        bottomConstX2 = bottomText.frame.minX - image.frame.minX
        originalBottomSpacing = bottomConstY
        
        if let topConstY = topConstY {
            topTextYConstraint.constant = topConstY
        }
        if let topConstX1 = topConstX1 {
            topTextXConstraint.constant = topConstX1
        }
        if let topConstX2 = topConstX2 {
            topTextX2Constraint.constant = topConstX2
        }
        if let bottomConstY = bottomConstY {
            bottomSpacing.constant = bottomConstY
        }
        if let bottomConstX1 = bottomConstX1 {
            bottomLeading.constant = bottomConstX1
        }
        if let bottomConstX2 = bottomConstX2 {
            bottomTrailing.constant = bottomConstX2
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        setConstraints()
    }

    func keyboardWillHide(notification: NSNotification){
        bottomSpacing.constant = originalBottomSpacing!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

