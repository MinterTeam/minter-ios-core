// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import MinterCore


class BaseQuickSpec : QuickSpec {
	override func spec() {
		MinterCoreSDK.initialize(urlString: "http://front-de.minter.network:48841")
	}

}
