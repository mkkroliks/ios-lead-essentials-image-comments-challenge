//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
	private static var OK_200: Int { return 200 }

	var isOK: Bool {
		return statusCode == HTTPURLResponse.OK_200
	}

	var is2xxStatus: Bool {
		return (200 ... 299).contains(statusCode)
	}
}
