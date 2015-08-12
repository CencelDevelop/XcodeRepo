//
//  SCCNuestroSitioViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 01/08/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCNuestroSitioViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var nuestroSitioWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            btnMenu.target = self.revealViewController()
            btnMenu.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // configurando el web view
        self.nuestroSitioWebView.delegate = self
        self.nuestroSitioWebView.scalesPageToFit = true
        
        loadCencelWebSite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCencelWebSite(){
        var requMethods = requestMethods()
        var url:NSURL = NSURL(string: requMethods.urlCencelSite)!
        var request:NSURLRequest = NSURLRequest(URL: url)
        self.nuestroSitioWebView.loadRequest(request)
        
    }
    
    @IBAction func backNavigation(sender: AnyObject) {
        if (self.nuestroSitioWebView.canGoBack){
            self.nuestroSitioWebView.goBack()
        }
    }
    
}
