//
//  Defaults+Keys.swift
//  iOS
//
//  Created by Rasmus Krämer on 03.02.24.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let customSleepTimer = Key<Int>("customSleepTimer", default: 0)
    
    static let authorsAscending = Key<Bool>("authorsAscending", default: true)
    static let showAuthorsRow = Key<Bool>("showAuthorsRow", default: false)
    static let disableDiscoverRow = Key<Bool>("disableDiscoverRow", default: false)
}
