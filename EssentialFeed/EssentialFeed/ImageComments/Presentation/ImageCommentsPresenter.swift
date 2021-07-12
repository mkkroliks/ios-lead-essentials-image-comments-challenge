//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

public final class ImageCommentsPresenter {
	public static var title: String {
		NSLocalizedString(
			"COMMENTS_VIEW_TITLE",
			tableName: "Comments",
			bundle: Bundle(for: ImageCommentsPresenter.self),
			comment: "Title for the comment view")
	}

	public static func map(_ comments: [ImageComment]) -> ImageCommentsViewModel {
		ImageCommentsViewModel(comments: comments)
	}
}
