//
//  SCCSucursalesTableViewController.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 31/05/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class tienda {
    var code:String = ""
    var nombre:String = ""
    
}

class SCCSucursalesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    var directorioTiendas = [tienda]()
    var tiendasFiltradas = [tienda]()
    var cuadroBusqueda = UISearchController()
    
    struct StoryboardConstants {
        /// The identifier string that corresponds to the SearchResultsViewController's view controller defined in the main storyboard.
        static let identifier = "SearchResultsViewControllerIdentifier"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // menu button
        if self.revealViewController() != nil {
            menuBarButtonItem.target = self.revealViewController()
            menuBarButtonItem.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        // cargando directorio de tiendas
        loadStores()
        
        // cargando cuadro de busqueda
        
        
        // cargando header image
        //var headerImageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 180))
        //headerImageView.contentMode = UIViewContentMode.ScaleToFill
        //headerImageView.image = UIImage(named: "bannr_sucursales.jpg")!
        //self.tableView.tableHeaderView = headerImageView
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Metodos de vista y negocio
    @IBAction func loadSearchBox(button: UIBarButtonItem){
        
        let searchResultsController = storyboard!.instantiateViewControllerWithIdentifier(SCCSucursalesTableViewController.StoryboardConstants.identifier) as! SCCSucursalesTableViewController
        
        
        cuadroBusqueda = UISearchController(searchResultsController: searchResultsController)
        cuadroBusqueda.searchResultsUpdater = searchResultsController
        cuadroBusqueda.hidesNavigationBarDuringPresentation = false
        
        
        
        self.cuadroBusqueda = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            
            
            
            controller.searchBar.sizeToFit()
            return controller
        })()
        
        
        presentViewController(cuadroBusqueda, animated: true, completion: nil)
        
        
        
        
    }
    
    func loadStores(){
        let reqMethods = requestMethods()
        let requestObj:SCCUrlRequestObject = SCCUrlRequestObject(fromMethod: reqMethods.getCencelStoresMethod, andData: "")
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(requestObj.getRequestGenerated(), queue: queue, completionHandler: { (response: NSURLResponse!, dataOut: NSData!, error: NSError!) -> Void in
            var err:NSError
            if(dataOut != nil){
                var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(dataOut, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
                dispatch_async(dispatch_get_main_queue(), {
                    let storesArray:Array = jsonResult["d"]! as! [[String : AnyObject]]
                    
                    for store:NSDictionary in storesArray{
                        // llenar el array de los nombres de las tiendas con sus codigos
                        var store1 = tienda()
                        store1.code = store["Code"] as! String
                        store1.nombre = store["Name"] as! String
                        self.directorioTiendas.append(store1)
                    }
                    self.tableView.reloadData()
                })
            }else{
                self.showError("Error del servicio. Contacte a CENCEL")
            }
        })
    }
    
    private func showError(messageStr:String){
        // mensaje en forma de alerta
        self.presentViewController(SCCUtils().generateAlertController(messageStr), animated: true, completion: nil)
    }
    
    // MARK: Search Delegate Method
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // filtrando por nombre de tienda (obtener las tiendas filtradas)
        tiendasFiltradas.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        
        // filtrando por nombre
        // sacar los nombres de las tiendas
        var tiendasNombresTemp = [String]()
        for tiendaIt in self.directorioTiendas
        {
            tiendasNombresTemp.append(tiendaIt.nombre)
        }
        
        // con los nombres de las tiendas, filtrarlos
        var array = (tiendasNombresTemp as NSArray).filteredArrayUsingPredicate(searchPredicate)
        array = array as! [String]
        
        // buscar en el array de string por las tiendas
        for var index = 0; index < directorioTiendas.count; index++ {
            // por cada tienda, compararla en el directorio
            var tiendaDic = directorioTiendas[index]
            for var index2 = 0; index2 < array.count; index2++ {
                if (array[index2] as! String == directorioTiendas[index].nombre){
                    // agregando
                    tiendasFiltradas.append(directorioTiendas[index])
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if (self.cuadroBusqueda.active){
            return tiendasFiltradas.count
        }else{
            return directorioTiendas.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // proceso en async
        var cell = tableView.dequeueReusableCellWithIdentifier("tiendaCell", forIndexPath: indexPath) as! SCCSucursalesTableViewCell
        dispatch_async(dispatch_get_main_queue(), {
            
            // info
            if (self.cuadroBusqueda.active){
                // filtradas
                if (self.tiendasFiltradas.count > 0 ){
                    cell.lblTiendaCodigo.text = self.tiendasFiltradas[indexPath.row].code
                    cell.lblTiendaNombre.text = self.tiendasFiltradas[indexPath.row].nombre
                }else{
                    cell.lblTiendaCodigo.text = ""
                    cell.lblTiendaNombre.text = ""
                    cell.backgroundView = nil
                }
            }else{
                // todas
                cell.lblTiendaCodigo.text = self.directorioTiendas[indexPath.row].code
                cell.lblTiendaNombre.text = self.directorioTiendas[indexPath.row].nombre
            }
        })
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showStoreSegue") {
            var destController:SCCSucursalesDetalleViewController = segue.destinationViewController as! SCCSucursalesDetalleViewController
            var selectedStore:tienda = tienda()
            var indexPath:NSIndexPath = self.tableView.indexPathForCell(sender as! SCCSucursalesTableViewCell)!
            
            if (self.cuadroBusqueda.active){
                // toma la tienda de las filtradas
                selectedStore = self.tiendasFiltradas[indexPath.row]
            }else{
                // toma la del directorio
                selectedStore = self.directorioTiendas[indexPath.row]
            }
            
            destController.selectedStore = selectedStore
        }
    }
}