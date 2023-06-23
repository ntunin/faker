//
//  Created by n.tyunin on 22.06.2023.
//

import Foundation

public enum XcodeError: Error, LocalizedError {
    case none(String)
    case write(String)
    
    public var errorDescription: String? {
        switch self {
        case .none(let path):
            return "Could not find project \(path)"
        case .write(let path):
            return "Could not write project \(path)"
        }
    }
}

public protocol HasXcodeService {
    var xcodeService: XcodeService { get }
}

public protocol XcodeService {
    func apply(list: [FakeXcode]?, folder: String) throws
}
