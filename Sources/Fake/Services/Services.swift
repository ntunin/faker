 
//
//  Created by n.tyunin on 22.06.2023.
//

import Foundation

public typealias AllServices = HasFakeProjectConfigParser &
                               HasXcodeService & 
                               HasFileService

let Services = ServiceFactory()

public final class ServiceFactory: AllServices {
    public lazy var fakeProjectConfigParser: FakeProjectConfigParser = FakeProjectConfigParserImp()
    public lazy var xcodeService: XcodeService = XcodeServiceImp()
    public lazy var fileService: FileService = FileServiceImp()
    
}
