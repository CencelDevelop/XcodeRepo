    //
    //  SCCSucursalesDetalleViewController.swift
    //  CENCEL
    //
    //  Created by Israel Perez Saucedo on 04/06/15.
    //  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
    //
    
    import UIKit
    import MapKit
    import MessageUI
    
    class SCCSucursalesDetalleViewController: UITableViewController, MFMailComposeViewControllerDelegate,UITableViewDelegate {
        
        // vars
        var selectedStore:tienda = tienda()
        var pointCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        //MARK: - Outlets
        @IBOutlet weak var LabelNombreTienda: UILabel!
        @IBOutlet weak var labelDireccionTienda: UILabel!
        @IBOutlet weak var labelTelefonoTienda: UILabel!
        @IBOutlet weak var labelEmailTienda: UILabel!
        @IBOutlet weak var addressCellView: UITableViewCell!
        
        // MARK: - View Methods
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.tableView.delegate=self
            
            // cargando background
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fondo_sucursales.jpg")!)
            
            // cargar datos de la tienda
            loadStore()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        func showError(messageStr:String){
            self.presentViewController(SCCUtils().generateAlertController(messageStr), animated: true, completion: nil)
        }
        
        // MARK: - Business Methods
        func loadStore(){
            // cargando los datos del servidor y cargando la informacion
            let reqMethods = requestMethods()
            let requestObj:SCCUrlRequestObject = SCCUrlRequestObject(fromMethod: reqMethods.getCencelStoreMethod, andData: "{\"storeCode\":\"" + self.selectedStore.code + "\"}")
            let queue:NSOperationQueue = NSOperationQueue()
            
            NSURLConnection.sendAsynchronousRequest(requestObj.getRequestGenerated(), queue: queue, completionHandler: { (response: NSURLResponse!, dataOut: NSData!, error: NSError!) -> Void in
                var err:NSError
                if(dataOut != nil){
                    var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(dataOut, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    
                    let store:NSDictionary = jsonResult["d"] as! [String: AnyObject]
                    dispatch_async(dispatch_get_main_queue(), {
                        // presentando la informacion
                        
                                            
                        // labels y botones
                        self.labelDireccionTienda.text =  String(format: "    %@", store["domicilio"] as! String)
                        self.labelDireccionTienda.textColor = UIColor.whiteColor()
                        self.labelEmailTienda.text = String(format: "    %@", store["email"] as! String)
                        self.LabelNombreTienda.text = self.selectedStore.nombre
                        self.LabelNombreTienda.textColor = UIColor.whiteColor()
                        self.labelTelefonoTienda.text = String(format: "    %@", store["telefono"] as! String)
                        
                        // mapa
                        var latitud:String = (store["coordinate"] as? String)!
                        
                        if (latitud != ""){
                            var coordinateArray = split(latitud) {$0 == ","}
                            self.pointCoordinate = CLLocationCoordinate2D(latitude: (coordinateArray[0] as NSString).doubleValue, longitude: (coordinateArray[1] as NSString).doubleValue)
                        }
                    })
                }
            })
        }
        
        func callPhone(){
            var phone:String = self.labelTelefonoTienda.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (phone != "") {
                let url:NSURL = NSURL(string: "tel://" + phone)!
                UIApplication.sharedApplication().openURL(url)
            } else {
                self.showError("No existe número de telefono configurado.")
            }
        }
        
        func sendEmail(){
            var email:String = self.labelEmailTienda.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (email != ""){
                var mailComposeControler: MFMailComposeViewController = generateMFMailController()
                if MFMailComposeViewController.canSendMail() {
                    mailComposeControler.setToRecipients([email])
                    self.presentViewController(mailComposeControler, animated: true, completion: nil)
                }else{
                    // error
                    self.showError("No se puede enviar correo.")
                }
            }else{
                // alerta
                self.showError("No existe cuenta de correo a donde enviar el mensaje.")
            }
        }
        
        func generateMFMailController() -> MFMailComposeViewController {
            let mailComposeController : MFMailComposeViewController = MFMailComposeViewController()
            mailComposeController.mailComposeDelegate = self
            mailComposeController.setSubject("Mensaje Enviado desde la App de CENCEL")
            mailComposeController.setMessageBody("Mensaje importante de uno de nuestros clientes.", isHTML: true)
            return mailComposeController
        }
        
        func initShowStore(){
            performSegueWithIdentifier("showStoreSegue", sender: self)
        }
        
        // MARK: - Delegados
        override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
            // seleccionando la celda jejeje
            var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
            
            if (selectedCell.reuseIdentifier == "callCell"){
                self.callPhone()
            }else if(selectedCell.reuseIdentifier == "mailCell") {
                self.sendEmail()
            }else if(selectedCell.reuseIdentifier == "locationCell") {
                self.initShowStore()
            }
            
            return indexPath
        }
        
        func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
            var mailMessage:String = ""
            switch result.value {
            case MFMailComposeResultCancelled.value:
                mailMessage = "Mensaje de correo Cancelado."
            case MFMailComposeResultSaved.value:
                mailMessage = "Mensaje de correo guardado en borradores."
            case MFMailComposeResultSent.value:
                mailMessage = "Mensaje de correo enviado."
            case MFMailComposeResultFailed.value:
                mailMessage = "Algo a ocurrido " + error.localizedDescription
            default:
                break
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            self.showError(mailMessage)
        }
        
        // MARK: - Navigation
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if (segue.identifier == "showStoreSegue"){
                var dstController:SCCStoreMapViewController = segue.destinationViewController as! SCCStoreMapViewController
                dstController.selectedStore = self.selectedStore
                dstController.coordinate = self.pointCoordinate
            }
        }
    }
