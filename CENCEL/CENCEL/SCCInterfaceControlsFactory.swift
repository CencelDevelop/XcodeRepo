//
//  UIControlsFactory.swift
//  CENCEL
//
//  Created by Israel Perez Saucedo on 23/06/15.
//  Copyright (c) 2015 Israel Perez Saucedo. All rights reserved.
//

import UIKit

class SCCInterfaceControlsFactory {
    // clase ayudante que genera un objeto de UIKit y lo devuelve
    // para generar mas de un objeto
    
    
    func createLabel(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, text:String, textColor:UIColor, align:NSTextAlignment, wordWrap:NSLineBreakMode) -> UILabel {
        var label:UILabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.textColor = textColor
        label.text = text
        label.textAlignment = align
        label.lineBreakMode = wordWrap
        return label
    }
    
    func createBlurredView(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, blurMode:UIBlurEffectStyle) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: blurMode)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        return blurEffectView
    }
    
    func createBibrancyView(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, blurEffect:UIBlurEffect, blurMode:UIBlurEffectStyle) -> UIVisualEffectView {
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        vibrancyEffectView.tag = 1
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: x, y: y, width: width, height: height)
        blurEffectView.addSubview(vibrancyEffectView)
        
        return blurEffectView
    }
    
    func createButton(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, method:Selector, target:AnyObject, title:String, textColor: UIColor) -> UIButton {
        
        // boton
        var btn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btn.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // titulo
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setTitleColor(textColor, forState: UIControlState.Normal)
        btn.titleLabel?.font.fontWithSize(25)
        
        btn.addTarget(target, action: method, forControlEvents: UIControlEvents.TouchUpInside)

        return btn
    }
    
    func createImageView(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, imageName:String) -> UIImageView {
        var imgView:UIImageView = UIImageView(frame: CGRectMake(x, y, width, height))
        var image:UIImage = UIImage(named: imageName)!
        
        imgView.image = image
        imgView.contentMode = UIViewContentMode.ScaleToFill
        
        return imgView
    }
    
    func createTextField(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, placeHolder:String, password:Bool, keyboardType:UIKeyboardType) -> UITextField {
        var textField:UITextField = UITextField(frame: CGRectMake(x, y, width, height))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.autocorrectionType = UITextAutocorrectionType.Yes
        textField.placeholder = placeHolder
        textField.returnKeyType = .Done
        textField.clearButtonMode = .Always
        textField.secureTextEntry = password
        textField.keyboardType = keyboardType
        
        return textField
    }
    
    func createLoadingLayer(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, blurEffect:UIBlurEffect, blurMode:UIBlurEffectStyle) -> UIVisualEffectView{
        var blurVibrancy = createBibrancyView(x, y: y, width: width, height: height, blurEffect: blurEffect, blurMode: blurMode)
        
        // agregando el loading activity
        var activityView = UIActivityIndicatorView(frame: CGRectMake((width/2) - 10, (height/2) - 10, 20, 20))
        activityView.tintColor = SCCUtils().getCencelColor()
        activityView.startAnimating()
        
        blurVibrancy.addSubview(activityView)
        
        return blurVibrancy
    }
}
