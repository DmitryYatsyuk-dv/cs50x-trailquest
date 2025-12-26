//
// TQParksServiceTests.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import XCTest
@testable import TrailQuest

final class TQParksServiceTests: XCTestCase {

    private var bundle: Bundle!

    override func setUp() {
        super.setUp()
        bundle = Bundle(for: TQParksServiceTests.self)
    }

    func testGetParksReturnsDecodedParks() async {
        let service = TQParksService(
            bundle: bundle,
            resourceName: "parks_test"
        )

        let state = await service.getParks()

        switch state {
        case .result(let parks):
            XCTAssertEqual(parks.count, 2)
            XCTAssertEqual(parks.first?.name, "Test Park")
            XCTAssertEqual(parks.first?.checkpoints.count, 2)
            XCTAssertEqual(parks.first?.checkpoints.first?.manualCode, "1234")
            XCTAssertNil(parks.first?.checkpoints.last?.manualCode)
        default:
            XCTFail("Expected decoded parks, got \(state)")
        }
    }

    func testGetParksReturnsFailureForMissingFile() async {
        let service = TQParksService(
            bundle: bundle,
            resourceName: "parks_missing"
        )

        let state = await service.getParks()

        switch state {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected failure for missing resource, got \(state)")
        }
    }

    func testGetParksReturnsFailureForInvalidJSON() async {
        let service = TQParksService(
            bundle: bundle,
            resourceName: "parks_invalid"
        )

        let state = await service.getParks()

        switch state {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected failure for invalid JSON, got \(state)")
        }
    }
}
