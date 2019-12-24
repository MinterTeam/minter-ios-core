// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import MinterCore

class BaseQuickSpec : QuickSpec {
	override func spec() {
		MinterCoreSDK.initialize(urlString: "https://texasnet.node-api.minter.network:8841")
	}

}
