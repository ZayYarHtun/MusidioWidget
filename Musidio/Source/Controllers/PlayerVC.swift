//
//  PlayerViewController.swift
//  Musidio
//
//  Created by Zay Yar Htun on 4/26/22.
//

import Cocoa
import MusidioEngine
import Settings
import Combine

// MARK: PlayerSize Enum
enum PlayerSize: String {
    case Cute
    case Fit
    case Huge
    
    func getSize() -> NSSize {
        switch self {
        case .Cute: return NSSize(width: 167, height: 167)
        case .Fit: return NSSize(width: 215, height: 215)
        case .Huge: return NSSize(width: 250, height: 250)
        }
    }
    
}

// MARK: PlayerVC
class PlayerVC: NSViewController {
    // Player UI Elements
    @IBOutlet weak var lblName: NSTextField!
    @IBOutlet weak var lblArtist: NSTextField!
    @IBOutlet weak var btnPlay: NSButton!
    @IBOutlet weak var lblRunTime: NSTextField!
    @IBOutlet weak var lblFullTime: NSTextField!
    @IBOutlet weak var playbackBar: PlaybackBar!
    
    // Player Views
    @IBOutlet weak var playerView: DraggableView!
    @IBOutlet weak var controlContainerView: NSView!
    @IBOutlet weak var playerWidth: NSLayoutConstraint!
    @IBOutlet weak var playerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnMenu: NSButton!
    @IBOutlet weak var menuView: NSView!
    
    private var player: Player?
    private var playerBundleId: String?
    private var disposeBag = Set<AnyCancellable>()
    private var debouncer = Debouncer()
    
    var hideControls: Bool = false {
        didSet {
            if isViewLoaded {
                controlContainerView.alphaValue = hideControls ? 0.0 : 1.0
            }
        }
    }
    
    var autoDepthControl: Bool = false
   
    // MARK: - Initializer
    static func createVC(player: Player?) -> PlayerVC? {
        if let vc = NSStoryboard.playerVC() as? PlayerVC {
            vc.player = player
            return vc
        }
        return nil
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMouseTracking()
        setupAction()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        setupPlayer()
    }
        
    // MARK: - Setup
    private func setupView() {
        playerView.layer?.cornerRadius = 20.0
        controlContainerView.addOverlayLayer()
        
        menuView.wantsLayer = true
        menuView.layer?.cornerRadius = menuView.frame.width / 2
        menuView.layer?.opacity = 0.8
        menuView.layer?.backgroundColor = CGColor.black
    }
    
    private func setupPlayer() {
        player?.playerState
            .print()
            .drive(receiveValue: { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .state(let playerData):
                    guard let track = playerData.track,
                          let control = playerData.control
                    else { return }

                    self.lblName.stringValue = track.name ?? ""
                    self.lblArtist.stringValue = track.artist ?? ""

                    if let artwork = track.artwork {
                        artwork.getImage { [weak self] image in
                            self?.playerView.image = image
                        }
                    }

                    self.playbackBar.totalSeconds = track.totalSeconds ?? 0.0
                    self.lblFullTime.stringValue = track.totalSeconds?.convertTimeText() ?? "0:00"
                    self.btnPlay.image = control == .paused ? Constants.Icons.play.image : Constants.Icons.pause.image
                    self.playerBundleId = playerData.playerBundleId
                    
                case .none: break
                }
            }).store(in: &disposeBag)
        
        player?.positionState
            .drive(receiveValue: { [weak self] position in
                guard let self = self else { return }
                
                self.playbackBar.updateProgress(position)
                self.lblRunTime.stringValue = position.convertTimeText()
            }).store(in: &disposeBag)
        
        playbackBar.didSeek = { [weak self] position in
            guard let self = self else { return }
            
            self.player?.setPosition(postion: position)
            self.lblRunTime.stringValue = position.convertTimeText()
        }
    }
    
    private func setupMouseTracking() {
        playerView.mouseTrack
            .removeDuplicates()
            .debounce(for: .seconds(0.005), scheduler: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .onView:
                    if self.hideControls {
                        self.controlContainerView.toggleOpacity(hide: false, animate: true)
                    }
                    
                    if self.autoDepthControl {
                        debouncer.debounce(interval: 0) {
                            self.view.window?.level = .statusBar
                        }
                    }
                    
                case .offView:
                    if self.hideControls {
                        self.controlContainerView.toggleOpacity(hide: true, animate: true)
                    }
                    
                    if self.autoDepthControl {
                        debouncer.debounce(interval: 1.5) {
                            self.view.window?.level = .init(-1)
                        }
                    }
                }
            }).store(in: &disposeBag)
    }
    
    private func setupAction() {
        // Popup player app...
        playerView.addMouseDownAction(deeplinkToPlayer)
        
    }
    
    // MARK: - Override Methods
    override func rightMouseDown(with event: NSEvent) {
        buildMenu()
    }
    
    // MARK: - Public API
    func setPlayerSize(_ size: NSSize, animate: Bool) {
        let oldFrame = view.window?.frame
        if animate {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.3
                self.playerWidth.animator().constant = size.width
                self.playerHeight.animator().constant = size.height
                self.view.layoutSubtreeIfNeeded()
            }
            guard let oldFrame = oldFrame, let window = view.window else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                window.setFrameOrigin(oldFrame.origin)
            }
        } else {
            self.playerWidth.constant = size.width
            self.playerHeight.constant = size.height
            self.view.layoutSubtreeIfNeeded()
        }
    }
    
    // MARK: - Actions
    @IBAction func btnPrevTapped(_ sender: Any) {
        player?.previous()
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        player?.next()
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        player?.togglePlay()
    }
    
    @IBAction func btnMenuTapped(_ sender: Any) {
        buildMenu()
    }
    
    private func deeplinkToPlayer() {
        guard let playerBundleId, let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: playerBundleId)
        else { return }
        NSWorkspace.shared.open(url)
    }
    
    
    // MARK: - Menu
    private func buildMenu() {
        let menu = NSMenu()
        
        menu.addItem(
            withTitle: "Preference",
            action: #selector(showPreference),
            keyEquivalent: ""
        ).target = self
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(
            withTitle: "Quit",
            action: #selector(terminateApp),
            keyEquivalent: ""
        ).target = self
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }
    
    @objc func showPreference() {
        if let wc = NSStoryboard.prefWC() as? PreferencesWindowController {
            wc.show()
        }
    }
    
    @objc func terminateApp() {
        NSApplication.shared.terminate(self)
    }
    
}
