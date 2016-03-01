//
//  ViewController.swift
//  Retro Calculator
//
//  Created by Flori on 28/02/2016.
//  Copyright © 2016 Florian Poncelin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var btnSound: AVAudioPlayer!
    var runningNumber = "0"
    var leftValString = ""
    var rightValString = ""
    var result = ""
    var currentOperation: Operation = Operation.Empty
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*************Prepping the sound of the buttons as the app loads***************
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav") //Getting the URL of the resource from its name and type
        let soundUrl = NSURL(fileURLWithPath: path!) //Assigning the URL to a constant
        
        do {
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl) //Trying to assign the Audioplayer file to the btnSound variable
            btnSound.prepareToPlay() //If assignment is successful, prepare the sound to be played
        } catch let err as NSError {
            print(err.debugDescription) //If error, display error in console
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func numberPressed(btn: UIButton!) {
        playSound()
        if runningNumber != "0" {
            runningNumber += "\(btn.tag)"
        } else {
            runningNumber = "\(btn.tag)"
        }
        outputLabel.text = runningNumber
    }

    @IBAction func dividePressed(sender: UIButton) {
        processOperation(Operation.Divide)
    }

    @IBAction func multiplyPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func subtractPressed(sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    
    @IBAction func addPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func equalsPressed(sender: UIButton) {
        processOperation(currentOperation)
    }
    
    @IBAction func clearPressed(sender: UIButton) {
        playSound()
        runningNumber = "0"
        leftValString = ""
        rightValString = ""
        result = ""
        currentOperation = Operation.Empty
        outputLabel.text = "0"
    }
    
    
    func processOperation(op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            //Run some math
            
            if runningNumber != "" && leftValString != "" {
                rightValString = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValString)! * Double(rightValString)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValString)! / Double(rightValString)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValString)! - Double(rightValString)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValString)! + Double(rightValString)!)"
                }
                
                leftValString = result
                outputLabel.text = result
                
            } else if runningNumber != "" && leftValString == "" {
                leftValString = runningNumber
                runningNumber = ""
            }
            
            
            currentOperation = op
            
        } else {
            //This is the first time an operator is pressed
            leftValString = runningNumber
            runningNumber = ""
            currentOperation = op
            
        }
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        btnSound.play()
    }
    
}

