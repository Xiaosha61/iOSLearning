//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Sasa's Macbook on 13/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {


    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "showWorried": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Smirk),
        "showAngry": FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Frown),
        "showHappy": FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "showMischievious": FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController{
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        
        
        if let facevc = destinationvc as? FaceViewController {
           
            // why the initial face is always "Angry"???
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton {
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
    

}
