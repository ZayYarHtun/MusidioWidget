//
//  Debouncer.swift
//  Musidio
//
//  Created by Zay Yar Htun on 8/20/23.
//

import Foundation

class Debouncer {
    private var workItem: DispatchWorkItem?

    func debounce(interval: TimeInterval, action: @escaping () -> Void) {
        workItem?.cancel()

        let newWorkItem = DispatchWorkItem {
            action()
        }
        workItem = newWorkItem

        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: newWorkItem)
    }
}
