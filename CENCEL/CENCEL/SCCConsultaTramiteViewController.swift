//
//  ViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 24/03/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.

import UIKit
import AVFoundation

class SCCConsultaTramiteViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // objetos de camara y video
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // cargando instancia de video
        //btnReactiva.enabled=false
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            
            if self.revealViewController() != nil {
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
            
            return
        }else{
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input as! AVCaptureInput)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
            qrCodeFrameView?.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView!)
            view.bringSubviewToFront(qrCodeFrameView!)
            //view.bringSubviewToFront(blurredView)
            //view.bringSubviewToFront(vibrantEffectView)
            //view.bringSubviewToFront(btnReactiva)
            
            if self.revealViewController() != nil {
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
    }
    
   // @IBAction func turnOnCamera(sender: AnyObject) {
     //   captureSession?.startRunning()
      //  btnReactiva.enabled=false
    //}
    
    func showError(messageStr:String){
        // mensaje en forma de alerta
        self.presentViewController(SCCUtils().generateAlertController(messageStr), animated: true, completion: nil)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                // es aqui donde tengo que lanzar el web service jejejejeje
                captureSession?.stopRunning()
                //btnReactiva.enabled=true
                if let dataNumber = NSNumberFormatter().numberFromString(metadataObj.stringValue) {
                    // si es numero, pasarlo a request y despues mostrar un popover controller con el resultado
                    let reqMethodsList = requestMethods()
                    var urlRequest:SCCUrlRequestObject = SCCUrlRequestObject(fromMethod: reqMethodsList.obtieneEstatusDataMethod,andData: "{\"folio\":\"" + metadataObj.stringValue + "\"}")
                    let queue:NSOperationQueue = NSOperationQueue()
                    
                    NSURLConnection.sendAsynchronousRequest(urlRequest.getRequestGenerated(), queue: queue, completionHandler: { (response: NSURLResponse!, dataOut: NSData!, error: NSError!) -> Void in
                        // completition handler (tipo javasript)
                        // se recibe el valor
                        var err:NSError
                        if(dataOut != nil){
                            var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(dataOut, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                            
                            // analizando la respuesta
                            let result:NSDictionary = jsonResult["d"]! as! [String: AnyObject]
                            var finalResult:String = ""
                            
                            if result["EstatusData"] as! String == "COMPLETADO" && result["EstatusTELCEL"] as! String == "ACEPTADO"{
                                finalResult = "Felicidades.\n El trámite ha quedado aceptado.\n pasa a tu sucursal por tu equipo."
                            } else if result["EstatusData"] as! String == "COMPLETADO" && result["EstatusTELCEL"] as! String == "RECHAZADO" {
                                finalResult = "Malas noticias.\n El trámite ha sido rechazado.\n acude a tu sucusal a verificar."
                            } else if result["EstatusData"] as! String == "PENDIENTE" {
                                finalResult = "Ten paciencia.\n El trámite sigue pendiente por parte de TELCEL."
                                
                            } else if result["EstatusData"] as! String == "PENDIENTE" && result["EstatusTELCEL"] as! String == "PENDIENTE" {
                                finalResult = "Ten paciencia.\n El trámite sigue pendiente por parte de TELCEL."
                            }
                                
                                // estatus de almacen preval y otros
                            else if result["EstatusData"] as! String == "EN PROCESO"{
                                finalResult = "Ten paciencia.\n El trámite llego al área de activaciones."
                            } else if result["EstatusData"] as! String == "EN PREVALIDACION"{
                                finalResult = "Ten paciencia.\n Se están corroborando los datos que has ingresado."
                            }  else if result["EstatusData"] as! String == "ALMACEN"{
                                finalResult = "Ten paciencia.\n El equipo que sueñas esta siendo asignado."
                            }  else if result["EstatusData"] as! String == "NO DISPONIBLE"{
                                finalResult = "Ten paciencia.\n El equipo que sueñas esta en proceso de compra."
                            }  else if result["EstatusData"] as! String == "TRANSITO LOCAL"{
                                finalResult = "Ten paciencia.\n Estamos esperando a que llegue tu equipo."
                            }  else if result["EstatusData"] as! String == "TRANSITO FORANEO"{
                                finalResult = "Ten paciencia.\n Estamos esperando a que llegue tu equipo."
                            }
                            
                            self.showError(finalResult)
                        } else {
                            self.showError("Algo a ocurrido. contacte a soporte.")
                        }
                    })
                } else{
                    self.showError("Datos Inválidos.")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

