//
//  SCCAppDtos.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 22/07/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCRegistroContacto: NSObject {
    var Comentario:String = ""
    var DispOrigin:String = ""
    var EmailContacto:String = ""
    var Nombre:String = ""
    var TelefonoContacto:String = ""
    
    init(comentario:String, dispOrigin:String, emailContacto:String, nombre:String, telefonoContacto:String) {
        super.init()
        self.Comentario = comentario
        self.DispOrigin = dispOrigin
        self.EmailContacto = emailContacto
        self.Nombre = nombre
    }
    
}