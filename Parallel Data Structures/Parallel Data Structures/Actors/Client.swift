//
//  File.swift
//  Parallel Data Structures
//
//  Created by pasha on 25.12.2021.
//

import Foundation

@available(macOS 12.0.0, *)
actor Client {
    
    public var PhoneNumber: String!
    private var waitingPeriod: Double!
    private var callDuration: Double!
    private var delay: Double!
    private var isCallAccepted: Bool!
    
    
    public init(delay: Double, phone: String) async throws {
        waitingPeriod = Double.random(in: 1...10)
        callDuration = Double.random(in: 10...120)
        self.delay = delay
        PhoneNumber = phone
        
        await AcceptedCall()
        await AwaitingCall()
        await Start()
    }
    private func Start() async {
        Thread.sleep(forTimeInterval: delay)
        print("Calling from \(PhoneNumber!)")
    }
    
    private func AcceptedCall() async {
        isCallAccepted = true
        print("Accepted call from \(PhoneNumber!). Talk duration \(callDuration!)")
        Thread.sleep(forTimeInterval: callDuration)
        print("Call from \(PhoneNumber!) has ended")
    }
    
    func AwaitingCall() async {
        print("Call from \(PhoneNumber!) is awaiting to be answered. Hang up after \(waitingPeriod!)")
        Thread.sleep(forTimeInterval: waitingPeriod)
        if !isCallAccepted {
            print("The waiting is over for \(PhoneNumber!). Hanging up")
        }
    }
}
