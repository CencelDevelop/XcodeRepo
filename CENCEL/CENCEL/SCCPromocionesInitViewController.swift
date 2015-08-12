//
//  SCCPromocionesInitViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 23/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit
import MediaPlayer

class SCCConsultaTramiteInitViewController: UIViewController {
    
    
    
    // reproductor de video
    var moviePlayer:MPMoviePlayerController?
    
    // vistas
    let clsControlsFactory:SCCInterfaceControlsFactory = SCCInterfaceControlsFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playVideo()
        
        // cargando objetos
        self.loadControls()
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo() -> Bool {
        let path = NSBundle.mainBundle().pathForResource("cencel_cam", ofType: "mov")
        let url = NSURL.fileURLWithPath(path!)
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        if let player = moviePlayer {
            player.view.frame = self.view.bounds
            player.controlStyle = MPMovieControlStyle.None
            player.prepareToPlay()
            player.repeatMode = MPMovieRepeatMode.One
            player.scalingMode = .AspectFill
            
            self.view.addSubview(player.view)
            return true
        }
        return false
    }
    
    func loadControls(){
        // punto central para localizarnos
        var centralPoint:CGPoint = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            // ahora con boton
        self.view.addSubview(loadInitCameraButton(centralPoint))
    }
    
    
    func loadInitCameraButton(centralPoint:CGPoint) -> UIView {
        // este boton tendra blur y vibrant
        
       var blurVibrancy = clsControlsFactory.createBibrancyView(0, y: self.view.frame.height - 80, width: self.view.frame.width, height: 80, blurEffect: UIBlurEffect(style: UIBlurEffectStyle.Dark), blurMode: UIBlurEffectStyle.Dark)
        
        var btn =  clsControlsFactory.createButton(10, y: 0, width: blurVibrancy.frame.width - 20, height: blurVibrancy.frame.height, method: Selector("launchCamera:"), target: self, title: "Iniciar", textColor: UIColor.whiteColor())
        
        blurVibrancy.viewWithTag(1)?.addSubview(btn)

        return blurVibrancy
    }
    
    func launchCamera(sender: UIButton!) {
        performSegueWithIdentifier("launchCameraSegue", sender: self)
    }
}