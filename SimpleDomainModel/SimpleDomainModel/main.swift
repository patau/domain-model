//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  enum currencyTypes: Double {
    case GBP = 0.5
    case EUR = 1.5
    case CAN = 1.25
  }
  
  public func convert(_ to: String) -> Money {
    var convertedAmount: Double = Double(self.amount)
    if self.currency != "USD" {
        switch self.currency {
        case "GBP":
            convertedAmount /= currencyTypes.GBP.rawValue
        case "EUR":
            convertedAmount /= currencyTypes.EUR.rawValue
        default:
            convertedAmount /= currencyTypes.CAN.rawValue
        }
        //Turn into param:to currency
        switch to {
        case "GBP":
            convertedAmount /= currencyTypes.GBP.rawValue
        case "EUR":
            convertedAmount /= currencyTypes.EUR.rawValue
        case "CAN":
            convertedAmount /= currencyTypes.CAN.rawValue
        default:
            //Should never actually get here; only case is USD, which is filtered out by if
            break
        }
    } else {
        switch to {
        case "GBP":
            convertedAmount *= currencyTypes.GBP.rawValue
        case "EUR":
            convertedAmount *= currencyTypes.EUR.rawValue
        case "CAN":
            convertedAmount *= currencyTypes.CAN.rawValue
        default:
            break
        }
    }
    return Money(amount: Int(convertedAmount), currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    var temp = Money(amount: self.amount, currency: self.currency)
    temp = convert(to.currency)
    return Money(amount: temp.amount + to.amount, currency: to.currency)
  }
    
  public func subtract(_ from: Money) -> Money {
    var from = from
    from = convert(from.currency)
    return Money(amount: from.amount - self.amount, currency: self.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let pay):
        return Int(pay * Double(hours))
    case .Salary(let pay):
        return pay
    }
  }
  
  open func raise(_ amt : Double) {
    print("In raise")
    print("Jobtype: \(self.type)")
    switch type {
    case .Hourly(let pay):
        type = JobType.Hourly(pay + amt)
    case .Salary(let pay):
        type = JobType.Salary(pay + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if self.age >= 16 {
            _job = value
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if self.age >= 18 {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
    //TODO: Why does the describing thing occur?
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.age >= 21 || spouse1.age >= 21 {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var total = 0
    for member in members {
        if (member.job != nil) {
            total += (member.job?.calculateIncome(2000))!
            //Debugging Purposes:
            //print("\(member.firstName)'s income \(String(describing: member.job?.calculateIncome(2000)))")
        }
        
    }
    return total
  }
}





