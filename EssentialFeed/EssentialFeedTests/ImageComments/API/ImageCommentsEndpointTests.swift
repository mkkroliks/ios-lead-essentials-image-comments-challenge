//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
	func test_imageCommentsEndpoint_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let sampleCommentsIds = [UUID(), UUID(), UUID()]

		sampleCommentsIds.forEach { imageId in
			let received = ImageCommentsEndpoint.get.url(baseURL: baseURL, imageId: imageId)
			let expected = URL(string: "http://base-url.com/v1/image/\(imageId.uuidString)/comments")!

			XCTAssertEqual(received, expected)
		}
	}
}
