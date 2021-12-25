//
//  BankAccount.swift
//  Parallel Data Structures
//
//  Created by pasha on 24.12.2021.
//

import Foundation

@available(macOS 12.0.0, *)
actor BankAccount {
    let id = UUID()
    private var balance: Double = 0.0
    
    func send(_ amount: Double, to destination: BankAccount) async throws {
        guard amount >= 0 else {
            print("negativeAmountTransfer")
            return
        }
        
        if (amount > balance) {
            print("insufficientFunds")
        }
        else {
            self.balance -= amount
            await destination.deposit(amount)
        }
    }
    
    func deposit(_ amount: Double) {
        guard amount >= 0 else {
            print("negativeAmountTransfer")
            return
        }
        self.balance += amount
    }
}
