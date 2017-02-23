//
//  ViewController.swift
//  FaceIt
//
//  Created by Sasa's Macbook on 13/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Frown) {
        didSet {
            updateUI() // first setup
        }
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            
            updateUI() //everytime you update the faceView
        }
    }

    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended{
            switch expression.eyes {
            case .Closed:
                expression.eyes = .Open
            case .Open:
                expression.eyes = .Closed
            case .Squinting:
                break
            }
        }
    }
    
    func increaseHappiness(){
        expression.mouth = expression.mouth.happierMouth()
        expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
    }
    func decreaseHappiness(){
        expression.mouth = expression.mouth.sadderMouth()
        expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0]
    
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: -0.5, .Furrowed: 0.5, .Normal: 0.0]
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 1.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 1.0
        }
        
    }


}

