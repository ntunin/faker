//
//  Created by n.tyunin on 22.06.2023.
//

import Yams

final class FakeProjectConfigParserImp: FakeProjectConfigParser {
    
    private lazy var decoder: YAMLDecoder = .init()
    
    func parse(yml: String) throws -> FakeProjectConfig {
        guard let content = try? String(contentsOfFile: yml) else {
            throw FakeProjectConfigParserError.read
        }
        guard let parser = try? Parser(yaml: content), 
              let node = try? parser.singleRoot() else {
            throw FakeProjectConfigParserError.syntax
        }
        guard let config = try? decoder.decode(FakeProjectConfig.self, from: node) else {
            throw FakeProjectConfigParserError.decode
        }
        return config
    }
}
