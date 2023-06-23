 //
//  Created by n.tyunin on 22.06.2023.
//

import Foundation

public enum FakeProjectConfigParserError: Swift.Error, LocalizedError {
    case read
    case syntax
    case decode
    
    public var errorDescription: String? {
        switch self {
        case .read:
            return "Could not read the input yml file"
        case .syntax:
            return "Could not parse input yml file"
        case .decode:
            return "Could not decode yml structure into fake project config"
        }
    }
}

public protocol HasFakeProjectConfigParser {
    var fakeProjectConfigParser: FakeProjectConfigParser { get }
}

public protocol FakeProjectConfigParser {
    func parse(yml: String) throws -> FakeProjectConfig
}
