//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sasa's Macbook on 12/02/17.
//  Copyright © 2017 Sasa's Macbook. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1*op2
}

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func addUnaryOperation(symbol: String, operation: @escaping (Double)->(Double)){
        operations[symbol] = Operation.UnaryOperation(operation)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation( {(op1: Double, op2: Double)->Double in
            return op1 * op2
            }
        ),
        "+": Operation.BinaryOperation( {(op1, op2) in return op1 + op2 } ),
        "-": Operation.BinaryOperation({ $0 - $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "=": Operation.Equals,
        "AC": Operation.ClearAll
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> (Double)) //a function as associated value
        case BinaryOperation((Double, Double)->(Double))
        case Equals
        case ClearAll
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .ClearAll:
                clear()
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double)->(Double)
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}
