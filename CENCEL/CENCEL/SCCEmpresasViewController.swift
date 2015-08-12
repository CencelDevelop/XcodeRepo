//
//  SCCEmpresasViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 29/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCEmpresasViewController: UITableViewController {

    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // comentario de prueba 6 de julio 
    
    // comentario desde afuera para obtener el cambio jejeje
    
    // otro mas para confirmar
    
    // ok ahora subo otro cambio

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
