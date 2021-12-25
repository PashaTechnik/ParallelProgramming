//
//  OSAtomicNode.swift
//  Parallel Data Structures
//
//  Created by pasha on 24.12.2021.
//

import Foundation
import CAtomics

protocol OSAtomicNode
{
  init(storage: UnsafeMutableRawPointer)
  var storage: UnsafeMutableRawPointer { get }
}

import func Darwin.libkern.OSAtomic.OSAtomicFifoEnqueue
import func Darwin.libkern.OSAtomic.OSAtomicFifoDequeue

/// A wrapper for OSAtomicFifoQueue
struct OSAtomicQueue<Node: OSAtomicNode>
{
  private let head: OpaquePointer

  init()
  {
    // Initialize an OSFifoQueueHead struct, even though we don't
    // have the definition of it. See libkern/OSAtomic.h
    //
    //  typedef    volatile struct {
    //    void    *opaque1;
    //    void    *opaque2;
    //    int     opaque3;
    //  } __attribute__ ((aligned (16))) OSFifoQueueHead;
    let size = MemoryLayout<OpaquePointer>.size
    let count = 3

    let h = UnsafeMutableRawPointer.allocate(byteCount: count*size, alignment: 16)
    for i in 0..<count
    {
      h.storeBytes(of: nil, toByteOffset: i*size, as: Optional<OpaquePointer>.self)
    }

    head = OpaquePointer(h)
  }

  var isEmpty: Bool {
    return UnsafeMutablePointer<OpaquePointer?>(head).pointee == nil
  }

  public var count: Int {
    var i = 0
    var node = UnsafePointer<UnsafeRawPointer?>(head).pointee
    while let current = node
    { // Iterate along the linked nodes while counting
      node = current.assumingMemoryBound(to: (UnsafeRawPointer?).self).pointee
      i += 1
    }
    return i
  }

  func release()
  {
    UnsafeMutableRawPointer(head).deallocate()
  }

  func enqueue(_ node: Node)
  {
    OSAtomicFifoEnqueue(head, node.storage, 0)
  }

  func dequeue() -> Node?
  {
    if let bytes = OSAtomicFifoDequeue(head, 0)
    {
      return Node(storage: bytes)
    }
    return nil
  }
}


import func Darwin.libkern.OSAtomic.OSAtomicEnqueue
import func Darwin.libkern.OSAtomic.OSAtomicDequeue

/// A wrapper for OSAtomicQueue
struct OSAtomicStack<Node: OSAtomicNode>
{
  private let head: OpaquePointer

  init()
  {
    let size = MemoryLayout<OpaquePointer>.size
    let count = 2

    let h = UnsafeMutableRawPointer.allocate(byteCount: count*size, alignment: 16)
    for i in 0..<count
    {
      h.storeBytes(of: nil, toByteOffset: i*size, as: Optional<OpaquePointer>.self)
    }

    head = OpaquePointer(h)
  }

  func release()
  {
    UnsafeMutableRawPointer(head).deallocate()
  }

  func push(_ node: Node)
  {
    OSAtomicEnqueue(head, node.storage, 0)
  }

  func pop() -> Node?
  {
    if let bytes = OSAtomicDequeue(head, 0)
    {
      return Node(storage: bytes)
    }
    return nil
  }
}
