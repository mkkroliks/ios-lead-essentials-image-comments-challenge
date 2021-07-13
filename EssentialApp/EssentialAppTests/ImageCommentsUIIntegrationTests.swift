//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import XCTest
import UIKit
import EssentialApp
import EssentialFeed
import EssentialFeediOS

class ImageCommentsUIIntegrationTests: XCTestCase {
	func test_feedView_hasTitle() {
		let (sut, _) = makeSUT()

		sut.loadViewIfNeeded()

		XCTAssertEqual(sut.title, ImageCommentsPresenter.title)
	}

	func test_loadFeedActions_requestFeedFromLoader() {
		let (sut, loader) = makeSUT()
		XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")

		sut.loadViewIfNeeded()
		XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a reload")

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected yet another loading request once user initiates another reload")
	}

	func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

		loader.completeFeedLoading(at: 0)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

		sut.simulateUserInitiatedReload()
		XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")

		loader.completeFeedLoadingWithError(at: 1)
		XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
	}

	func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
		let imageComment0 = makeComment(message: "first message", createdAt: Date(), authorUserName: "first username")
		let imageComment1 = makeComment(message: "second message", createdAt: Date(), authorUserName: "second username")
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		assertThat(sut, isRendering: [])

		loader.completeFeedLoading(with: [imageComment0], at: 0)
		assertThat(sut, isRendering: [imageComment0])

		sut.simulateUserInitiatedReload()
		loader.completeFeedLoading(with: [imageComment0, imageComment1], at: 1)
		assertThat(sut, isRendering: [imageComment0, imageComment1])
	}

	func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
		let imageComment0 = makeComment(message: "first message", createdAt: Date(), authorUserName: "first username")
		let imageComment1 = makeComment(message: "second message", createdAt: Date(), authorUserName: "second username")
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		loader.completeFeedLoading(with: [imageComment0, imageComment1], at: 0)
		assertThat(sut, isRendering: [imageComment0, imageComment1])

		sut.simulateUserInitiatedReload()
		loader.completeFeedLoading(with: [], at: 1)
		assertThat(sut, isRendering: [])
	}

	func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
		let imageComment0 = makeComment(message: "first message", createdAt: Date(), authorUserName: "first username")
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		loader.completeFeedLoading(with: [imageComment0], at: 0)
		assertThat(sut, isRendering: [imageComment0])

		sut.simulateUserInitiatedReload()
		loader.completeFeedLoadingWithError(at: 1)
		assertThat(sut, isRendering: [imageComment0])
	}

	func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
		let (sut, loader) = makeSUT()
		sut.loadViewIfNeeded()

		let exp = expectation(description: "Wait for background queue")
		DispatchQueue.global().async {
			loader.completeFeedLoading(at: 0)
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1.0)
	}

	func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertEqual(sut.errorMessage, nil)

		loader.completeFeedLoadingWithError(at: 0)
		XCTAssertEqual(sut.errorMessage, loadError)

		sut.simulateUserInitiatedReload()
		XCTAssertEqual(sut.errorMessage, nil)
	}

	func test_tapOnErrorView_hidesErrorMessage() {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertEqual(sut.errorMessage, nil)

		loader.completeFeedLoadingWithError(at: 0)
		XCTAssertEqual(sut.errorMessage, loadError)

		sut.simulateErrorViewTap()
		XCTAssertEqual(sut.errorMessage, nil)
	}

	// MARK: - Helpers

	private func makeSUT(
		selection: @escaping (FeedImage) -> Void = { _ in },
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: ListViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = ImageCommentsUIComposer.feedComposedWith(feedLoader: loader.loadPublisher)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, loader)
	}

	private func makeComment(id: UUID = UUID(), message: String = "any message", createdAt: Date = Date(), authorUserName: String = "any username") -> ImageComment {
		return ImageComment(id: id, message: message, createdAt: createdAt, authorUserName: authorUserName)
	}
}
