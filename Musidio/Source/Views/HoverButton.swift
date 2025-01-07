//
//  MediaButton.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/21/22.
//

import AppKit

@IBDesignable class HoverButton: NSButton {
    
    @IBInspectable var idleImage: NSImage?
    @IBInspectable var hoverImage: NSImage?
    
    // MARK: - Initializer
    override init(frame: NSRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        setupTrackingArea()
    }
    
    // MARK: - Setup
    private func setupTrackingArea() {
        let trackArea = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited,
            .activeAlways],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackArea)
    }
    
    // MARK: - Override Methods
    override func mouseEntered(with event: NSEvent) {
        self.image = hoverImage
    }
    
    override func mouseExited(with event: NSEvent) {
        self.image = idleImage
    }
}
