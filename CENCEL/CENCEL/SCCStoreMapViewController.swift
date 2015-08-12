//
//  SCCStoreMapViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 05/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit
import MapKit

class SCCStoreMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mkmMapa3d: MKMapView!
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var selectedStore:tienda = tienda()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.selectedStore.nombre
        
        // confirugando el mapa con el punto de la tienda seleccionada
        self.mkmMapa3d.delegate = self
        self.mkmMapa3d.mapType = MKMapType.Satellite
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        var storePoint:MKPointAnnotation = MKPointAnnotation()
        storePoint.coordinate = self.coordinate
        storePoint.title = self.selectedStore.nombre
        storePoint.subtitle = self.selectedStore.code
        self.mkmMapa3d.addAnnotation(storePoint)
        
        // centro y region
        let region = MKCoordinateRegionMakeWithDistance(storePoint.coordinate, 300, 300)
        self.mkmMapa3d.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            return nil
        }
        let reuseId = "ccstorepoint"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            // icon
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"ccstore.png")
            anView.canShowCallout = true
            
            // boton con accion
            var callOut:UIButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
            
            callOut.addTarget(self, action: "callOutClick:", forControlEvents: UIControlEvents.TouchUpInside)
            anView.rightCalloutAccessoryView = callOut
        }
        else {
            anView.annotation = annotation
        }
        
        return anView
    }
    
    func callOutClick(sender: AnyObject){
        NSLog("hola click")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}