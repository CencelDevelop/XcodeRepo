//
//  SCCEmpresasDetalleViewController.swift
//  CENCEL
//
//  Created by Mario Enrique Espinoza Angel on 22/07/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import MessageUI

class SCCEmpresasDetalleViewController: UITableViewController, MFMailComposeViewControllerDelegate,UITableViewDelegate {
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate=self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError(messageStr:String){
        self.presentViewController(SCCUtils().generateAlertController(messageStr), animated: true, completion: nil)
    }
    
    func callPhone(){
        var phone:String = self.phoneLabel.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (phone != "") {
            let url:NSURL = NSURL(string: "tel://" + phone)!
            UIApplication.sharedApplication().openURL(url)
        } else {
            self.showError("No existe número de telefono configurado.")
        }
    }
    
    func sendEmail(){
        var email:String = self.mailLabel.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
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
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // seleccionando la celda jejeje
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if (selectedCell.reuseIdentifier == "callCell"){
            self.callPhone()
        }else if(selectedCell.reuseIdentifier == "mailCell") {
            self.sendEmail()
            
            
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
    
    
}