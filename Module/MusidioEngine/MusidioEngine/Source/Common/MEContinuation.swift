//
//  MEContinuation.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/17/23.
//

import Foundation

public class MEContinuation<T> {
    private var continuation: CheckedContinuation<T, Never>?
    
    public init() {}
    
    public func start(_ continuation: CheckedContinuation<T, Never>) {
        self.continuation = continuation
    }
    
    public func success(_ result: T) {
        guard let continuation = self.continuation else { return }
        self.continuation = nil
        continuation.resume(returning: result)
    }
}
