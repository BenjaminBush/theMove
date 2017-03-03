//
//  Package.swift
//  theMove
//
//  Created by Ben Bush on 3/3/17.
//  Copyright © 2017 theMove. All rights reserved.
//

import Foundation
import PackageDescription

let package = Package(name: "theMove", targets:[], dependencies: [..Package(url:"https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1,0,0)...<Version(3, .max, .max)),])
