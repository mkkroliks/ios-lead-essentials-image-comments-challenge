//
// Copyright © 2020 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
	func test_imageCommentsEndpoint_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let sampleCommentsIds = [
			UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000")!,
			UUID(uuidString: "321e4567-e89b-12d3-a456-426614174000")!,
			UUID(uuidString: "132e4567-e89b-12d3-a456-426614174000")!
		]

		let expectedURLs = [
			URL(string: "http://base-url.com/v1/image/123E4567-E89B-12D3-A456-426614174000/comments")!,
			URL(string: "http://base-url.com/v1/image/321E4567-E89B-12D3-A456-426614174000/comments")!,
			URL(string: "http://base-url.com/v1/image/132E4567-E89B-12D3-A456-426614174000/comments")!
		]

		zip(sampleCommentsIds, expectedURLs).forEach { (imageId, expectedURL) in
			let received = ImageCommentsEndpoint.get.url(baseURL: baseURL, imageId: imageId)
			XCTAssertEqual(received, expectedURL)
		}
	}
}
