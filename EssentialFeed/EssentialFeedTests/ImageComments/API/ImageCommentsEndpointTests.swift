//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
	func test_feed_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let sampleCommentsIds = ["1", "50", "200"]

		sampleCommentsIds.forEach { commentId in
			let received = ImageCommentsEndpoint.get.url(baseURL: baseURL, commentId: commentId)
			let expected = URL(string: "http://base-url.com/image/\(commentId)/comments")!

			XCTAssertEqual(received, expected)
		}
	}
}
