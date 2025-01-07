//
//  PlaybackBar.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/12/22.
//

import AppKit

class PlaybackBar: NSView {
    
    public var totalSeconds = 0.0
    public var didSeek: ((Double) -> Void)?
    
    private let progressLayer = CALayer()
    private let barColor = NSColor.init(hex: 0x2E2E30)
    private let progressColor = NSColor.init(hex: 0xDBDBDB)
    private var width: Double = 0.0
    
    // MARK: - Initializer
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func layout() {
        width = frame.width
    }
    
    // MARK: - Setup
    private func setupView() {
        wantsLayer = true
        layer?.backgroundColor = barColor.cgColor
        
        layer?.cornerRadius = 2
        progressLayer.cornerRadius = 1
        
        progressLayer.frame = NSRect(x: 0.0, y: 0.0, width: 0.0, height: frame.height)
        progressLayer.backgroundColor = progressColor.cgColor
        layer?.insertSublayer(progressLayer, at: 0)
    }
    
    override func mouseDown(with event: NSEvent) {
        let touchPoint = self.convert(event.locationInWindow, from: nil)
        updateProgressLayerOnMouseDown(point: touchPoint.x)
    }
    
    // MARK: - Public API
    public func updateProgress(_ position: Double) {
        guard progressLayer.frame.size.width <= frame.width else {
            progressLayer.frame.size.width = 0
            return
        }
        
        let chunk = convertSecondsToChunk()
        guard position >= chunk else {
            progressLayer.frame.size.width = 0
            return
        }
        
        let nearestChunk = round(position * chunk)
        if nearestChunk.isNormal {
            progressLayer.frame.size.width = nearestChunk
        }
    }
        
    // MARK: - Private API
    private func updateProgressLayerOnMouseDown(point: Double) {
        let chunk = convertSecondsToChunk()
        let chunkCount = round(point / chunk)
        let nearestChunk = chunk * chunkCount
        let position = (nearestChunk / width) * totalSeconds
        progressLayer.frame.size.width = nearestChunk
        didSeek?(position)
    }
    
    private func convertSecondsToChunk() -> Double {
        return width / totalSeconds
    }
    
}
