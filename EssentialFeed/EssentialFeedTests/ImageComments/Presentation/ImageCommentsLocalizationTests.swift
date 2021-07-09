//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
	func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
		let table = "Feed"
		let bundle = Bundle(for: FeedPresenter.self)

		assertLocalizedKeyAndValuesExist(in: bundle, table)
	}
}
