//
//  Manager+Default.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation

public extension AccountManager {
    class var `default`: AccountManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension TransactionManager {
    class var `default`: MinterCore.TransactionManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension CoinManager {
    class var `default`: CoinManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension StatusManager {
    class var `default`: StatusManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension CandidateManager {
    class var `default`: CandidateManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension ValidatorManager {
    class var `default`: ValidatorManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension BlockManager {
    class var `default`: BlockManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}

public extension EventManager {
    class var `default`: EventManager {
        let httpClient = APIClient.shared
        let manager = self.init(httpClient: httpClient)
        return manager
    }
}
