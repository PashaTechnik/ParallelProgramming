//
//  CallCenter.swift
//  Parallel Data Structures
//
//  Created by pasha on 25.12.2021.
//

import Foundation


@available(macOS 12.0.0, *)
actor CallCenter {
    private var operatorStates: Array<OperatorState> = [OperatorState(id: "1"), OperatorState(id: "2"), OperatorState(id: "3"), OperatorState(id: "4")]
    
    private var awaitingCallers: Array<AwaitingCaller>? = nil
    
    public init() async throws {
        
    }
    
    private func NotifyCallHangUp() async throws {
        let caller = awaitingCallers?.first
        let availableOperator = operatorStates.first { OperatorState in
            !OperatorState.IsBusy!
        }
        if caller != nil && availableOperator != nil {
            awaitingCallers = awaitingCallers?.filter({ $0.Phone == caller?.Phone})
            availableOperator?.Call = Call(phoneNumber: caller!.Phone)
        }
    }
    
    private func HandleCall(msg: Call) async throws {
        let availableOperator = operatorStates.first { OperatorState in
            !OperatorState.IsBusy!
        }
        
        if availableOperator != nil {
            availableOperator!.Call = msg
            var acceptedCall = AcceptCall(phone: msg.Phone, operatorId: availableOperator!.Id)
        }
        else {
            awaitingCallers?.append(AwaitingCaller(phone: msg.Phone))
        }
    }
    
}
