//
//  Created by n.tyunin on 22.06.2023.
//

import Foundation
import PathKit

final class FileServiceImp: FileService {
    
    private struct FileHandler {
        let patterns: [String]?
        let handler: (Path) throws -> Void
    }

    func apply(replace: [FakeReplace]?, remove: [FakeRemove]?, folder: String) throws {
        let directory = Path(folder)
        guard let files = try? directory.recursiveChildren() else {
            throw FileError.contents(folder)
        }
        try apply(replace: replace, files: files)
        try apply(remove: remove, files: files)
    }
    
    private func apply(replace: [FakeReplace]?, files: [Path]) throws {
        guard let replace else {
            return
        }
        try enumerateFiles(files, with: replace.map({ replace in 
            .init(patterns: replace.files) { path in
                try self.replace(from: replace.from, to: replace.to, in: path)
            } 
        }))
    }
    
    private func apply(remove: [FakeRemove]?, files: [Path]) throws {
        guard let remove else {
            return
        }
        try enumerateFiles(files, with: remove.map({ remove in 
            .init(patterns: remove.files) { path in
                try self.remove(string: remove.string, in: path)
            } 
        }))
    }
    
    private func enumerateFiles(_ files: [Path], with handlers: [FileHandler]) throws {
        try files.forEach { path in
            for handler in handlers {
                if let patterns = handler.patterns {
                    try patterns.forEach { pattern in
                        if path.match(pattern) {
                            try handler.handler(path)
                        }
                    }
                } else {
                    try handler.handler(path)
                }
            }
        }
    }
    
    private func remove(string: String, in path: Path) throws {
        try replace(from: string, to: "", in: path)
    }
    
    private func replace(from: String, to: String, in path: Path) throws {
        guard let content = try? path.read(.utf8) else {
            throw FileError.contents(path.string)
        }
        let updated = content.replacingOccurrences(of: from, with: to)
        do {
            try path.write(updated)
        } catch {
            throw FileError.write(path.string)
        }
    }
}
