//
//  SCCPromocionesDetalleViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 17/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCPromocionesDetalleViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var promoImageView: UIImageView!
    var selectedImage:UIImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.promoImageView.image = self.selectedImage
        
        
        // configurando la imagen para que haga pan y zoom, jueves ;)
        self.scrollView.minimumZoomScale = 0.0
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.contentSize = self.promoImageView.frame.size
        self.scrollView.delegate = self
    }
    
    //MARK: - Scrolling delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.promoImageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
