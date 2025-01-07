//
//  SpotifyPlayerTests.swift
//  MusidioEngineTests
//
//  Created by Zay Yar Htun on 5/24/22.
//

import XCTest
import RxTest
import RxSwift
@testable import MusidioEngine

class SpotifyPlayerTests: XCTestCase {
    var player: SpotifyPlayer!
    var application: MockSpotifyApplication!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUpWithError() throws {
        player = PlayerConcreteFactory.createPlayer(.spotify) as? SpotifyPlayer
        application = player.spotify as? MockSpotifyApplication
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        player = nil
        application = nil
        disposeBag = nil
        scheduler = nil
    }
    
    func testNext() {
        let testObserver = scheduler.createObserver(Double.self)
        player._positionState
            .asDriver()
            .skip(1)
            .drive(testObserver)
            .disposed(by: disposeBag)
        
        player.next()
        
        XCTAssertEqual(testObserver.events, [.next(0, 0.0)])
        XCTAssert(application.result == .nextTrack)
    }
    
    func testPrevious() {
        let testObserver = scheduler.createObserver(Double.self)
        player._positionState
            .asDriver()
            .skip(1)
            .drive(testObserver)
            .disposed(by: disposeBag)
        
        player.previous()
        
        XCTAssertEqual(testObserver.events, [.next(0, 0.0)])
        XCTAssert(application.result == .previousTrack)
    }
    
    func testTogglePlay() {
        player.togglePlay()
        XCTAssert(application.result == .playPause)
    }
    
    func testSetPosition() {
        player.setPosition(postion: 1000.0)
        XCTAssert(application.result == .playerPosition)
    }
    
    func testPlayerState() {
        let mockTrack = Track(name: "Name", artist: "Artist", album: "Album", artwork: Artwork(url: URL(string: "https://www.test.com/12345")), totalSeconds: 200)
        let mockPlayerMetadata = PlayerData(track: mockTrack, control: .paused)
        
        let mockTrack1 = Track(name: "Name1", artist: "Artist1", album: "Album1", artwork: Artwork(url: URL(string: "https://www.test.com/12345")), totalSeconds: 200)
        let mockPlayerMetadata1 = PlayerData(track: mockTrack1, control: .paused)
        
        scheduler.createColdObservable([.next(10, PlayerState.state(mockPlayerMetadata)),
                                        .next(20, PlayerState.state(mockPlayerMetadata1))])
            .bind(to: player._playerState)
            .disposed(by: disposeBag)
        
        
        let testObserver = scheduler.createObserver(PlayerState.self)
        player._playerState
            .asDriver()
            .skip(1)
            .drive(testObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(testObserver.events, [.next(10, PlayerState.state(mockPlayerMetadata)),
                                             .next(20, PlayerState.state(mockPlayerMetadata1))])
    }

}
