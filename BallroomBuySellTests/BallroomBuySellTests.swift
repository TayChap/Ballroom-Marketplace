//
//  BallroomBuySellTests.swift
//  BallroomBuySellTests
//
//  Created by Taylor Chapman on 2022-11-12.
//

import XCTest
@testable import BallroomBuySell

final class BallroomBuySellTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - My Test Example
    func testStandard() throws {
        let item = SaleItem(userId: "test")
        XCTAssertEqual(item.userId, "test")
    }
    
    func testBoundary() throws {
        // TODO!
    }
    
    func testSpecialCase() throws {
        // TODO!
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
