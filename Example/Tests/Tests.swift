// https://github.com/Quick/Quick

import Quick
import Nimble
@testable import MinterCore

class BaseQuickSpec : QuickSpec {
	override func spec() {
		MinterCoreSDK.initialize(urlString: "http://68.183.211.176:8843")
	}

}
