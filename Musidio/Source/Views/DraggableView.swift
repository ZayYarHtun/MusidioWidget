//
//  Draggable.swift
//  Musidio
//
//  Created by Zay Yar Htun on 5/9/22.
//

import AppKit
import Combine

enum MouseTrackArea {
    case onView
    case offView
}

typealias MouseDownAction = () -> Void

class DraggableView: NSView {
    
    var image: NSImage? {
        didSet {
            setImage(oldImage: oldValue, newImage: image)
        }
    }
    
    var mouseTrack: AnyPublisher<MouseTrackArea, Never> {
        return mousePosition.eraseToAnyPublisher()
    }
    
    private var mousePosition: CurrentValueSubject<MouseTrackArea, Never> = .init(.offView)
    private var mouseDownAction: MouseDownAction?
    private var mouseTrackArea: NSTrackingArea?
    
    // MARK: - Override Methods
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        updateMouseTrackArea(frame)
    }
    
    override func mouseEntered(with event: NSEvent) {
        mousePosition.send(.onView)
    }
    
    override func mouseExited(with event: NSEvent) {
        mousePosition.send(.offView)
    }
    
    // MARK: - Public API
    func addMouseDownAction(_ action: MouseDownAction?) {
        mouseDownAction = action
    }
    
    // MARK: - Private API
    private func setImage(oldImage: NSImage?, newImage: NSImage?) {
        var rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let oldCGImage = oldImage?.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        let newCGImage = newImage?.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        
        // Animate image change between old and new images
        if let old = oldCGImage, let new = newCGImage {
            let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.contents))
            animation.values = [old, new]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.calculationMode = .cubic
            animation.duration = 1.0
            layer?.add(animation, forKey: "ImageChangeAnimation")
        }
        
        // Set final image
        if let image = newImage {
            self.layer?.contents = image.cgImage(forProposedRect: &rect, context: nil, hints: nil)
        }
    }
    
    private func updateMouseTrackArea(_ rect: CGRect) {
        if let area = mouseTrackArea {
            removeTrackingArea(area)
        }
        mouseTrackArea = NSTrackingArea(
            rect: rect,
            options: [.mouseEnteredAndExited,
            .activeAlways],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(mouseTrackArea!)
    }
    
    override func mouseDown(with event: NSEvent) {
        let playbackBarContainerViewId = NSUserInterfaceItemIdentifier("1000")
        if let view = hitTest(event.locationInWindow),
           view.identifier != playbackBarContainerViewId && view.superview?.identifier != playbackBarContainerViewId {
            mouseDownAction?()
        }
    }

}
