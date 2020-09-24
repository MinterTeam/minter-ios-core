// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import MinterCore

class BaseQuickSpec: QuickSpec {
	override func spec() {
    MinterCoreSDK.initialize(urlString: "http://node.chilinet.minter.network:28843", network: .testnet)
	}

}
