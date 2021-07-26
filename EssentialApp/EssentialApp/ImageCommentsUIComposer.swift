//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class ImageCommentsUIComposer {
	private init() {}

	private typealias ImageCommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], ImageCommentsViewAdapter>

	public static func imageCommentsComposedWith(
		imageCommentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
	) -> ListViewController {
		let presentationAdapter = ImageCommentsPresentationAdapter(loader: imageCommentsLoader)

		let imageCommentsController = makeImageCommentsViewController(title: ImageCommentsPresenter.title)
		imageCommentsController.onRefresh = presentationAdapter.loadResource

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: ImageCommentsViewAdapter(controller: imageCommentsController),
			loadingView: WeakRefVirtualProxy(imageCommentsController),
			errorView: WeakRefVirtualProxy(imageCommentsController),
			mapper: { comments in
				ImageCommentsPresenter.map(comments)
			})

		return imageCommentsController
	}

	private static func makeImageCommentsViewController(title: String) -> ListViewController {
		let bundle = Bundle(for: ListViewController.self)
		let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
		let imageCommentsController = storyboard.instantiateInitialViewController() as! ListViewController
        imageCommentsController.title = title
		return imageCommentsController
	}
}
