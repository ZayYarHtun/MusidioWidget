//
//  NSView.swift
//  Musidio
//
//  Created by Zay Yar Htun on 4/26/22.
//

import Cocoa

@IBDesignable extension NSView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer?.cornerRadius = newValue
        }
        get {
            layer?.cornerRadius ?? 0.0
        }
    }
}

extension NSView {
    func addOverlayLayer() {
        self.wantsLayer = true
        let layer = CAGradientLayer()
        layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        layer.frame = self.frame
        let overlayColor = NSColor.init(hex: 0x1C1C1E).cgColor
        layer.colors = [overlayColor, overlayColor,
                        NSColor.clear.cgColor, NSColor.clear.cgColor]
        layer.opacity = 0.6
        self.layer?.insertSublayer(layer, at: 0)
    }
    
    func toggleOpacity(hide: Bool, animate: Bool) {
        guard animate else {
            self.alphaValue = hide ? 0.0 : 1.0
            return
        }
        
        self.layer?.removeAllAnimations()
        let opacity = self.alphaValue
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = opacity
        animation.toValue = hide ? 0.0 : 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = hide ? 1.0 : 0.5
        self.layer?.add(animation, forKey: "toggleAnimation")
        self.alphaValue = hide ? 0.0 : 1.0
    }
}
