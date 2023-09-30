//
//  EventManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 18/01/2019.
//

import Foundation

public enum EventManagerError: Error {
    case incorrectPayload
}

/// Block Manager
public class EventManager: BaseManager {
    public func events(height: String = "0", with completion: (([String: Any]?, Error?) -> Void)?) {
        let blocksURL = MinterAPIURL.events.url()

        httpClient.getRequest(blocksURL, parameters: ["height": height]) { response, error in

            var res: [String: Any]?
            var err: Error?

            defer {
                completion?(res, err)
            }

            guard error == nil else {
                err = error
                return
            }

            /// trying to parse response
            guard let resp = response.data as? [String: Any] else {
                err = EventManagerError.incorrectPayload
                return
            }

            res = resp
        }
    }
}
