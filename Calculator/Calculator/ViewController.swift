//
//  ViewController.swift
//  Calculator
//
//  Created by Sasa's Macbook on 11/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import UIKit

var calculatorCount = 0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel! // implicitly unwrapped optional
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCount += 1
        print("Loaded up a new Calculator: count = \(calculatorCount)")
        /*
        brain.addUnaryOperation(symbol: "Red√") {
            self.display.textColor = UIColor.red //where memory cycle happens
            return sqrt($0)
        }
        */
        /*
        brain.addUnaryOperation(symbol: "Red√") { [unowned me = self] in
            me.display.textColor = UIColor.red
            return sqrt($0)
        }
        */
        brain.addUnaryOperation(symbol: "Red√") { [weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.red //where memory cycle happens
            return sqrt($0)
        }
    }
    
    deinit {
        calculatorCount -= 1
        print("Calculator left the heap: count = \(calculatorCount)")
    }
    
    @IBAction private func touchDigits(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text! // force unwrapping
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
        
    }
    
 

    //computed property:
    private var displayValue: Double {
        get{  // get a Double to Calculate
            return Double(display.text!)!
        }
        set {  // set to a String to display
            display.text = String(newValue)
        }
    }

    
    private var brain = CalculatorBrain()
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if sender.currentTitle! != "Red√" {
            display.textColor = UIColor.white
        }
            
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle { //    optional binding
            brain.performOperation(symbol: mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
            userIsInTheMiddleOfTyping = false
        }
    }
    
    

}

