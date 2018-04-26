//
//  SynchronizedArray.swift
//
//  A Thread-Safe Array
//  Source: http://basememara.com/creating-thread-safe-arrays-in-swift/
//  Only necessary parts implemented below
//
//  trial-verifone-detector
//
//  Created by Herman Slatman on 01/04/2018.
//  Copyright © 2018 Herman Slatman. All rights reserved.
//

import Foundation

class SynchronizedArray<Element> {
    fileprivate let queue = DispatchQueue(label: "synchronized.array", attributes: .concurrent)
    fileprivate var array = [Element]()
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter element: The element to append to the array.
    func append( _ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    /// Calls the given closure on each element in the sequence in the same order as a for-in loop.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a parameter.
    func forEach(_ body: (Element) -> Void) {
        queue.sync { self.array.forEach(body) }
    }
    
    /// Removes all elements from the array.
    ///
    /// - Parameter completion: The handler with the removed elements.
    func removeAll(completion: (([Element]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            
            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }
    
}

