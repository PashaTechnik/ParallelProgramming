//
//  CASAtomic.swift
//  Parallel Data Structures
//
//  Created by pasha on 25.12.2021.
//

import Foundation
import CAtomics
import SwiftAtomics

class CASAtomic {
    private var lockedThread: AtomicReference<Thread>? = nil
    private var threads: SynchronizedArray<Thread>? = nil
    func Lock() {
        while ((lockedThread?.CAS(current: .current, future: nil)) != nil) {
            Thread.sleep(forTimeInterval: 0)
        }
    }
    
    func Unlock() {
        lockedThread?.CAS(current: nil , future: lockedThread?.take())
    }

    
    func Wait() {
        let current = Thread.current
        if (lockedThread?.take() != Thread.current)
        {
            return
        }
        threads?.append(newElement: current)
        Unlock()
        while ((threads) != nil)
        {
            Thread.sleep(forTimeInterval: 0)
        }
        Lock();
    }
    
    func Notify() {
        let current = Thread.current
        if (lockedThread?.take() != current)
        {
            fatalError("ThreadStateException")
        }

        threads?.removeAtIndex(index: 2)
    }
    
    func NotifyAll() {
        if lockedThread!.take() != Thread.current
        {
            fatalError("ThreadStateException")
        }

        threads?.clear()
    }
    
}
