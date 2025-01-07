//
//  PlayerElapsedTimeTicker.swift
//  MusidioEngine
//
//  Created by Zay Yar Htun on 5/20/23.
//

import Foundation
import Combine

public class PlayerElapsedTimeTicker {
    
    public var elapsedTime: CurrentValueSubject<(seconds: Double, timestamp: Date), Never> = CurrentValueSubject((0.0, Date()))
    
    private var timer: Cancellable?
    
    public init() {}
    
    public func setElapsedTime(seconds: Double, timestamp: Date) {
        elapsedTime.send((seconds, timestamp))
    }
    
    public func toogleTicking(start: Bool) {
        if start {
            timer?.cancel()
            timer = Timer
                .publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .map({ _ in
                    return (seconds: self.elapsedTime.value.seconds +  Date().timeIntervalSince(self.elapsedTime.value.timestamp), timestamp: Date())
                })
                .assign(to: \.value, on: elapsedTime)
        } else {
            timer?.cancel()
        }
    }
}
