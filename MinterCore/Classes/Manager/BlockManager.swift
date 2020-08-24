//
//  BlockManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 18/01/2019.
//

import Foundation

public enum BlockManagerError: Error {
	case incorrectPayload
}

/// Block Manager
public class BlockManager: BaseManager {

	public func blocks(height: String = "0", with completion: (([String : Any]?, Error?) -> ())?) {

		let blocksURL = MinterAPIURL.blocks(height: height).url()

		self.httpClient.getRequest(blocksURL, parameters: [:]) { (response, error) in

			var res: [String: Any]?
			var err: Error?

			defer {
				completion?(res, err)
			}

			guard nil == error else {
				err = error
				return
			}

			/// trying to parse response
			guard let resp = response.data as? [String : Any] else {
				err = BlockManagerError.incorrectPayload
				return
			}
			res = resp
		}
	}

}
