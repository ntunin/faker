//
//  Created by n.tyunin on 22.06.2023.
//

import Foundation

public enum FileError: Error, LocalizedError {
    case contents(String)
    case write(String)
    
    public var errorDescription: String? {
        switch self {
        case .contents(let path):
            return "Could not read content of \(path)"
        case .write(let path):
            return "Could not write content to \(path)"
        }
    }
}

public protocol HasFileService {
    var fileService: FileService { get }
}

public protocol FileService {

    func apply(replace: [FakeReplace]?, remove: [FakeRemove]?, folder: String) throws
}
