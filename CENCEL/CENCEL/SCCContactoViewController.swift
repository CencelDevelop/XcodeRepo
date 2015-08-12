//
//  SCCContactoViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 31/05/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCContactoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    var txtNombre:UITextField = UITextField()
    var txtEmail:UITextField = UITextField()
    var txtTelefono:UITextField = UITextField()
    var txtComentario:UITextView = UITextView()
    //var btnCallToCallCenter:UIButton = UIButton()
    //var btnSendComment:UIButton = UIButton()
    var phoneCallCenter:String = ""
    
    let clsControlsFactory:SCCInterfaceControlsFactory = SCCInterfaceControlsFactory()
    
    // MARK: - view methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuBarButtonItem.target = self.revealViewController()
            menuBarButtonItem.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        loadBackground()
        
        loadControls()
        
        getCallCenterPhone()
    }
    
    func loadBackground(){
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fondo_sucursales.jpg")!)
    }
    
    func loadControls(){
        // scroll view
        var scrollView:UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width,self.view.frame.height))
        scrollView.scrollEnabled=true
        scrollView.showsVerticalScrollIndicator = true
        
        var innerScrollView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height + 50))
        scrollView.contentSize = CGSizeMake(innerScrollView.frame.width, innerScrollView.frame.height)
        
        // imagen de header
        let imgHeader = clsControlsFactory.createImageView(0, y: 0, width: self.view.frame.width, height: 200, imageName: "header_contacto")
        scrollView.addSubview(imgHeader)
        
        // formulario de contacto
        txtNombre =  clsControlsFactory.createTextField(10, y: 210, width: self.view.frame.width - 20, height: 30, placeHolder: "Nombre Completo", password: false, keyboardType: UIKeyboardType.Default)
        innerScrollView.addSubview(txtNombre)
        txtNombre.delegate = self
        
        txtEmail = clsControlsFactory.createTextField(10, y: 250, width: self.view.frame.width - 20, height: 30, placeHolder: "Correo Electrónico", password: false, keyboardType: UIKeyboardType.EmailAddress)
        innerScrollView.addSubview(txtEmail)
        txtEmail.delegate = self
        
        txtTelefono = clsControlsFactory.createTextField(10, y: 290, width: self.view.frame.width - 20, height: 30, placeHolder: "Teléfono", password: false, keyboardType: UIKeyboardType.PhonePad)
        innerScrollView.addSubview(txtTelefono)
        txtTelefono.delegate = self
        
        
        innerScrollView.addSubview(clsControlsFactory.createLabel(10, y: 330, width: self.view.frame.width - 20, height: 30, text: "Comentario:", textColor: UIColor.blackColor(), align: NSTextAlignment.Justified, wordWrap: NSLineBreakMode.ByWordWrapping))
        txtComentario = UITextView(frame:CGRectMake(10, 370, self.view.frame.width - 20, 150))
        txtComentario.textAlignment = NSTextAlignment.Justified
        txtComentario.textContainer.lineBreakMode = NSLineBreakMode.ByWordWrapping
        txtComentario.textContainer.maximumNumberOfLines = 20
        
        innerScrollView.addSubview(txtComentario)
        scrollView.addSubview(innerScrollView)
        self.view.addSubview(scrollView)
        
        // botones en navigation bar
        var imgBtnCallPhone:UIImage = UIImage(named: "telephone.png")!
        var btnCallPhone:UIBarButtonItem = UIBarButtonItem(image: imgBtnCallPhone, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("callToCallCenter:"))
        
        var imgSendComment:UIImage = UIImage(named: "send.png")!
        var btnSendComment:UIBarButtonItem = UIBarButtonItem(image: imgSendComment, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("sendComment:"))
        
        var arrayButton:NSArray = NSArray(objects: btnSendComment, btnCallPhone)
        self.navigationItem.rightBarButtonItems = arrayButton as [AnyObject]
        
//        var blurVibrancy = clsControlsFactory.createBibrancyView(0, y: self.view.frame.height - 105, width: self.view.frame.width, height: 65, blurEffect: UIBlurEffect(style: UIBlurEffectStyle.Light), blurMode: UIBlurEffectStyle.Light)
//        
//        btnCallToCallCenter =  clsControlsFactory.createButton(10, y: 0, width: (self.view.frame.width / 2), height: blurVibrancy.frame.height, method: Selector("callToCallCenter:"), target: self, title: "Llamar a Call Center", textColor: SCCUtils().getCencelColor())
//        
//        btnSendComment =  clsControlsFactory.createButton((self.view.frame.width / 2) + 10, y: 0, width: (self.view.frame.width / 2), height: blurVibrancy.frame.height, method: Selector("sendComment:"), target: self, title: "Enviar", textColor: SCCUtils().getCencelColor())
//        
//        blurVibrancy.viewWithTag(1)?.addSubview(btnCallToCallCenter)
//        blurVibrancy.viewWithTag(1)?.addSubview(btnSendComment)
//        
//        self.view.addSubview(blurVibrancy)
    }
    
    func getCallCenterPhone(){
        let reqMethods = requestMethods()
        let requestObj:SCCUrlRequestObject = SCCUrlRequestObject(fromMethod: reqMethods.getContactInfoMethod, andData: "{\"isEmpresa\": \"0\"}")
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(requestObj.getRequestGenerated(), queue: queue, completionHandler: { (response: NSURLResponse!, dataOut: NSData!, error: NSError!) -> Void in
            var err:NSError
            if(dataOut != nil){
                var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(dataOut, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                let info:NSDictionary = jsonResult["d"] as! [String: AnyObject]
                self.phoneCallCenter = info["telefono"] as! String
            }else{
                self.showError("Error del servicio. Contacte a CENCEL")
            }
        })
    }
    
    func callToCallCenter(sender: AnyObject){
        if (self.phoneCallCenter != "") {
            let url:NSURL = NSURL(string: "tel://" + self.phoneCallCenter)!
            UIApplication.sharedApplication().openURL(url)
        } else {
            self.showError("No existe número de telefono configurado.")
        }
    }
    
    func showError(messageStr:String){
        self.presentViewController(SCCUtils().generateAlertController(messageStr), animated: true, completion: nil)
    }
    
    func sendComment(sender:AnyObject){
        // enviar el comentrio al sistema
        if (self.txtComentario.text != "" && self.txtEmail.text != "" && self.txtNombre.text != "" && self.txtTelefono.text != ""){
            var version:String = "iOS - " + UIDevice.currentDevice().systemVersion
            // enviando la informacion
            
            var data = String(format:"{\"datosRegistro\":{\"Comentario\":\"%@\", \"DispOrigen\":\"%@\", \"EmailContacto\":\"%@\", \"Nombre\":\"%@\", \"TelefonoContacto\":\"%@\"}}", self.txtComentario.text, version, self.txtEmail.text, self.txtNombre.text, self.txtTelefono.text)
            
            var loadingView = clsControlsFactory.createLoadingLayer(0, y: 0, width: self.view.frame.width, height: self.view.frame.height, blurEffect: UIBlurEffect(style: UIBlurEffectStyle.Dark), blurMode: UIBlurEffectStyle.Dark)
            loadingView.tag = 2
            self.view.addSubview(loadingView)
            
            let reqMethods = requestMethods()
            let requestObj:SCCUrlRequestObject = SCCUrlRequestObject(fromMethod: reqMethods.sendCommentsMethod, andData: data)
            let queue:NSOperationQueue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(requestObj.getRequestGenerated(), queue: queue, completionHandler: { (response: NSURLResponse!, dataOut: NSData!, error: NSError!) -> Void in
                var err:NSError
                if(dataOut != nil){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.viewWithTag(2)?.removeFromSuperview()
                        var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(dataOut, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                        let result:NSString = jsonResult["d"]! as! NSString
                        
                        // array de un solo objeto
                        self.showError(result as! String)
                        self.txtComentario.text = ""
                        self.txtEmail.text = ""
                        self.txtNombre.text = ""
                        self.txtTelefono.text = ""
                    })
                }else{
                    self.view.viewWithTag(2)?.removeFromSuperview()
                    self.showError("Error del servicio. Contacte a CENCEL")
                }
            })
        }else{
            self.showError("Falta informacíon por completar.")
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}