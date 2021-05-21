//
//  ZeplinEnvironment.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

struct ZeplinAccessTokenKey: EnvironmentKey {
    static var defaultValue = ""
}

struct ZeplinProjectIDKey: EnvironmentKey {
    static var defaultValue = ""
}

public extension EnvironmentValues {
    var zeplinProjectId: String {
        get {
            self[ZeplinProjectIDKey.self]
        }
        set {
            self[ZeplinProjectIDKey.self] = newValue
        }
    }

    var zeplinAccessToken: String {
        get {
            self[ZeplinAccessTokenKey.self]
        }
        set {
            self[ZeplinAccessTokenKey.self] = newValue
        }
    }
}
