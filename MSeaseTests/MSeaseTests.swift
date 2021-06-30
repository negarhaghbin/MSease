//
//  MSeaseTests.swift
//  MSeaseTests
//
//  Created by Negar on 2021-06-29.
//

import XCTest
@testable import MSease

class MSeaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTimeStrings() throws {
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: 0, minute: 8, second: 0, of: Date())
        let time = date!.getTime()
        XCTAssertEqual(time, "12:08 AM")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
