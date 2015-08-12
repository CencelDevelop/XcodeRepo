//
//  SCCPromocionesViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 11/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCPromocionesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var promosActivity: UIActivityIndicatorView!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    // arreglo de imagenes
    var contentImagesNames = [""]
    var sliderUrls = [""]
    var selectedImage:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fondo_sucursales.jpg")!)
        
        self.promosActivity.startAnimating()
        
        // cargar imagenes del servidor
        loadImageFromServer()
        
        // menu button
        if self.revealViewController() != nil {
            menuBarButtonItem.target = self.revealViewController()
            menuBarButtonItem.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Business Methods
    func loadImageFromServer(){
        let reqMethods = requestMethods()
        let requestObj:SCCUrlRequestObject = SCCUrlRequestObject(fromMethod: reqMethods.getPromosMethod, andData: "")
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(requestObj.getRequestGenerated(), queue: queue, completionHandler: { (response: NSURLResponse!, dataOut: NSData!, error: NSError!) -> Void in
            var err:NSError
            if(dataOut != nil){
                var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(dataOut, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                var imagesArray:Array = jsonResult["d"]! as! [[String : AnyObject]]
                
                self.contentImagesNames = []
                for imageDict:NSDictionary in imagesArray{
                    // descargar imagenes en local e ir presentando local para aumentar rendimiento
                    var imageToDownload:String = imageDict["FotoActual"] as! String
                    if (imageToDownload != ""){
                        // guardando nombre de imagen en ds array
                        self.contentImagesNames.append(imageToDownload)
                        
                        // descargando imagen
                        var imageRoute = reqMethods.urlFiles + reqMethods.locationPromos + imageToDownload
                        let url:NSURL = NSURL(string:imageRoute)!
                        self.getImageDataFromUrl(url) { data in
                            // guardar imagen en sistema de archivos para despues usarla
                            self.saveImageToPhone(data!, fileName: imageToDownload)
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.promosActivity.stopAnimating()
                    self.promosActivity.hidden = true
                    // cargar layout
                    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                    layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
                    
                    // recargar collection
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.collectionViewLayout = layout
                    self.collectionView.reloadData()
                })
            }
        })
    }
    
    func getImageDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func saveImageToPhone(data: NSData, fileName: String){
        //var imageDownloaded = UIImage(data: data)
        var documentsDir:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)[0] as! String
        var fileNameFull = documentsDir + "/" + fileName
        data.writeToFile(fileNameFull, options: NSDataWritingOptions.AtomicWrite, error: nil)
    }
    
    // MARK: - collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentImagesNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // configura la celda !! oooo
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("PromoCell", forIndexPath: indexPath) as! SCCPromoCollectionViewCell
        if (self.contentImagesNames[indexPath.row] != ""){
            // personalizar la celda presentando imagen  de la promo descargada de internet al dispositivo
            self.loadImageLocal(self.contentImagesNames[indexPath.row] as String, imageView: cell.promoImage)
        }
        return cell
    }
    
    func loadImageLocal(fileName:String, imageView:UIImageView){
        // cargar imagen localmente
        
        let manager:NSFileManager = NSFileManager.defaultManager()
        var documentsDir:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)[0] as! String
        var fileNameFull = documentsDir + "/" + fileName
        
        if (manager.fileExistsAtPath(fileNameFull)){
            imageView.image = UIImage(contentsOfFile: fileNameFull)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! SCCPromoCollectionViewCell
//        self.selectedImage = cell.promoImage.image!
//        self.performSegueWithIdentifier("ShowPhotoSegue", sender: nil)
//    }
//    
//    
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "ShowPhotoSegue"){
//            var dstController:SCCPromocionesDetalleViewController = segue.destinationViewController as! SCCPromocionesDetalleViewController
//            dstController.selectedImage = self.selectedImage
//        }
//    }
    
}
