 
//
//  Created by n.tyunin on 22.06.2023.
//

import Foundation

public struct FakeReplace: Codable {
    let files: [String]?
    let from: String
    let to: String
}

public struct FakeRemove: Codable {
    let files: [String]?
    let string: String
}

public struct FakeXcodeDropList: Codable {
    let except: Bool
    let list: [String]?
}

public struct FakeXcodeDrop: Codable {
    let targets: FakeXcodeDropList?
    let capabilities: FakeXcodeDropList?
    let buildPhases: [String]?
}

public struct FakeXcode: Codable {
    let project: String
    let drop: FakeXcodeDrop
}

public struct FakeProjectConfig: Codable {
    let replace: [FakeReplace]?
    let remove: [FakeRemove]?
    let xcode: [FakeXcode]?
}
