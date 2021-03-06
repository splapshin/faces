//
//  ViewController.swift
//  Faces
//
//  Created by Sergey Lapshin on 08.11.16.
//  Copyright © 2016 Sergey Lapshin. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(
                UIPinchGestureRecognizer(
                    target: faceView,
                    action: #selector(FaceView.changeScale(_:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.inceaseHappiness))
            
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.deceaseHappiness))
            
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            //let rotationGestureRecognizer = UIRotationGestureRecognizer
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    
    
    func inceaseHappiness(){
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func deceaseHappiness(){
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    @IBAction func rotateFace(_ recognizer: UIRotationGestureRecognizer) {
        print(recognizer.rotation)
        faceView.transform = faceView.transform.rotated(by: recognizer.rotation)
        //faceView.transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0.0
    }
    
    private var mouthCurvatures = [ FacialExpression.Mouth.Frown: -1.0, .Smirk: -0.5, .Smile: 1.0, .Grin: 0.5, .Neutral: 0.0 ]
    
    private var eyeBrowsTilt = [ FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0]
    
    private func updateUI(){
        switch expression.eyes {
        case .Open:
            faceView.eyesOpen = true
        case .Closed:
            faceView.eyesOpen = false
        case .Squinting:
            faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowsTilt[expression.eyeBrows] ?? 0.0
    }
}

