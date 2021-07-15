//
//  iTunesSearchAPITests.swift
//  iTunesSearchAPITests
//
//  Created by David Kuo on 2021/7/13.
//

import XCTest
@testable import iTunesSearchAPI

class TrackListViewModelTests: XCTestCase {
    func testSearchResultCanGet() {
        let expectation = self.expectation(description: "Search can success")
        let viewModel = TrackListViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            viewModel.getSearchResultListFrom(keyword: "Justin Bieber", success: expectation.fulfill)
        }
        waitForExpectations(timeout: 7, handler: nil)
    }
}
