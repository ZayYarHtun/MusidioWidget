//
//  PlayerFactoryTests.swift
//  MusidioEngineTests
//
//  Created by Zay Yar Htun on 5/24/22.
//

import XCTest
import MusidioEngine

class PlayerFactoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreatePlayer() {
        let type: PlayerType = .spotify
        let result = PlayerConcreteFactory.createPlayer(type)
        
        XCTAssert((result as? SpotifyPlayer) != nil)
    }

}
