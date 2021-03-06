//
//  Event.swift
//  Rx
//
//  Created by Krunoslav Zaher on 2/8/15.
//  Copyright (c) 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation


/**
Represents sequence event

Sequence grammar:
Next\* (Error | Completed)
*/
public enum Event<Element> : CustomStringConvertible {
    /**
    Next element is produced
    */
    case Next(Element)
    
    /**
    Sequence terminates with error
    */
    case Error(ErrorType)
    
    /**
    Sequence completes sucessfully
    */
    case Completed
    
    /**
    - returns: Description of event
    */
    public var description: String {
        get {
            switch self {
            case .Next(let value):
                return "Next(\(value))"
            case .Error(let error):
                return "Error(\(error))"
            case .Completed:
                return "Completed"
            }
        }
    }
}

/**
Compares two events. They are equal if they are both the same member of `Event` enumeration.

In case `Error` events are being compared, they are equal in case their `NSError` representations are equal (domain and code).
*/
public func == <T: Equatable>(lhs: Event<T>, rhs: Event<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Completed, .Completed): return true
    case (.Error(let e1), .Error(let e2)):
        let error1 = e1 as NSError
        let error2 = e2 as NSError
        
        return error1.domain == error2.domain
            && error1.code == error2.code
    case (.Next(let v1), .Next(let v2)): return v1 == v2
    default: return false
    }
}

extension Event {
    /**
    - returns: Is `Completed` or `Error` event
    */
    public var isStopEvent: Bool {
        get {
            switch self {
            case .Next:
                return false
            case .Error: fallthrough
            case .Completed: return true
            }
        }
    }
    
    /**
    - returns: If `Next` event, returns element value.
    */
    public var element: Element? {
        get {
            switch self {
            case .Next(let value):
                return value
            case .Error: fallthrough
            case .Completed: return nil
            }
        }
    }
    
    /**
    - returns: If `Error` event, returns error.
    */
    public var error: ErrorType? {
        get {
            switch self {
            case .Next:
                return nil
            case .Error(let error):
                return error
            case .Completed:
                return nil
            }
        }
    }
}