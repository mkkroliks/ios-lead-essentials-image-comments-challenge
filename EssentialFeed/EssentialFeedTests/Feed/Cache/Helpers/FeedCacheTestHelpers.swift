//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
	return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
	let models = [uniqueImage(), uniqueImage()]
	let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
	return (models, local)
}

func uniqueComments() -> [ImageComment] {
	let uniqueComments = [uniqueComment(), uniqueComment()]
	return uniqueComments
}

func uniqueComment() -> ImageComment {
	ImageComment(id: UUID(), message: "any", createdAt: Date(), authorUserName: "any")
}

extension Date {
	func minusFeedCacheMaxAge() -> Date {
		return adding(days: -feedCacheMaxAgeInDays)
	}

	private var feedCacheMaxAgeInDays: Int {
		return 7
	}
}
