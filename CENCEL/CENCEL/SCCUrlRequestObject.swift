//
//  urlRequestObject.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 01/04/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import Foundation

struct requestMethods{
    var getPromosMethod:String = "getPromos"
    var getCencelStoresMethod:String = "getCencelStores"
    var getCencelStoreMethod:String = "getCencelStore"
    var getItemsMethod:String = "getITems"
    var getPlansByTypeMethod:String = "getPlanesByType"
    var getPricesByItemMethod:String = "getPricesByItem"
    var getCotizationResultMethod = "getCotizationResult"
    var getContactInfoMethod:String = "getContactInfo"
    var obtieneEstatusDataMethod:String = "ObtieneEstatusData"
    var tipoTramiteN1Method:String = "tipoTramiteN1"
    var tipoTramiteN2Method:String = "tipoTramiteN2"
    var getCustomerSearchCriteriaMethod:String = "getCustomerSearchCriteria"
    var getcustomersMethod:String = "getCustomers"
    var generateCustomerMethod:String = "generateCustomer"
    var updateCustomerMethod:String = "updateCustomer"
    var getIdentitiesMethod:String = "getIdentities"
    var getHousePapersMethod:String = "getHousePapers"
    var getPlanesMethod:String = "getPlanes"
    var getBrandsMethod:String = "getBrands"
    var getModelsMethod:String = "getModels"
    var getPriceMethod:String = "getPrice"
    var generateNewDataMethod:String = "generateNewData"
    var sendCommentsMethod:String = "sendComments"
    
    var locationPromos:String = "promos/"
    var tiendasBack:String = "tiendas/back/"
    var tiendasFachada:String = "tiendas/fachada/"
    var urlFiles:String = "http://smartcen.net:6091/"
    var urlCencelSite = "http://www.cencel.com.mx"
}

public class SCCUrlRequestObject {
    let urlService:String = "http://smartcen.net:6091/srv/SmartMobileControllerService.svc/"
    var urlRequest:NSMutableURLRequest?
    
    init(fromMethod urlString:String!, andData dataString:String!){
        
        // generando y configurando el request
        var dataString2 = dataString
        var url:NSURL = NSURL(string: urlService + urlString)!
        urlRequest = NSMutableURLRequest(URL: url)
        urlRequest?.HTTPMethod="POST"
        urlRequest?.timeoutInterval=60
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest?.HTTPShouldHandleCookies = false
        
        // agregando datos en http body
        if (dataString == ""){
            // append data
            dataString2 = "{}"
            urlRequest?.HTTPBody = dataString2.dataUsingEncoding(NSUTF8StringEncoding)
        } else {
            urlRequest?.HTTPBody = dataString2.dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
    
    func getRequestGenerated() -> NSURLRequest {
        return urlRequest!
    }
}