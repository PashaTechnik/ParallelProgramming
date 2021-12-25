//
//  File.swift
//  Parallel Data Structures
//
//  Created by pasha on 25.12.2021.
//

import Foundation

class OperatorState {
    public var Call: Call?
    public var Id: String!
    
    
    public var IsBusy: Bool?
    
    public init(id: String) {
        Id = id
    }
    
    public init(id: String, call: Call)
    {
        Id = id
        Call = call
    }
}

class AcceptCall : CallProtocol {
    var Phone: String = ""
    var OperatorId: String = ""

    public init(phone: String, operatorId: String)
    {
        OperatorId = operatorId
        Phone = phone
    }
    
}

protocol CallProtocol {
    var Phone: String { get }
}

class Call : CallProtocol {
    var Phone: String

    public init(phoneNumber: String)
    {
        Phone = phoneNumber
    }
}

class CallHangUp: CallProtocol {
    var Phone: String

    public init(phone: String)
    {
        Phone = phone
    }
}


class AwaitingCallHangUp: CallProtocol {
    var Phone: String

    public init(phone: String)
    {
        Phone = phone
    }
}

class AwaitingCall: CallProtocol {
    var Phone: String

    public init(phone: String)
    {
        Phone = phone
    }
}

class AwaitingCaller {
    var Phone: String
    
    public init(phone: String)
    {
        Phone = phone
    }
}
