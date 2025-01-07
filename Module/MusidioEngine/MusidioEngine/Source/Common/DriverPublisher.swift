//
//  DriverPublisher.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/14/23.
//

import Foundation
import Combine

public typealias DriverPublisher<Output> = AnyPublisher<Output, Never>

extension Publisher where Failure == Never {
    
    public func asDriverPublisher() -> DriverPublisher<Output> {
        self.eraseToAnyPublisher()
    }
    
    public func drive(receiveValue closure: @escaping (Output) -> Void) -> AnyCancellable {
        self
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: closure)
    }
}
