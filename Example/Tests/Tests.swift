// https://github.com/Quick/Quick

@testable import MinterCore
import Nimble
import Quick

class BaseQuickSpec: QuickSpec {
    override func spec() {
        MinterCoreSDK.initialize(urlString: "https://texasnet.node-api.minter.network:8841")
    }
}
