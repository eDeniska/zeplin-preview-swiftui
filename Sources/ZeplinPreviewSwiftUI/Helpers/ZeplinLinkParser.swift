//
//  ZeplinLinkParser.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation

struct ZeplinLinkParser {
    let projectId: String?
    let componentId: String?

    init(link: String) {
        // zpl://project?pid=NNNNNN
        // zpl://components?pid=NNNNNNN&coids=MMMMMMM

        if let components = URLComponents(string: link), components.scheme == "zpl" {
            let component = components.queryItems?.first { $0.name == "coids"}?.value
            componentId = component
            let project = components.queryItems?.first { $0.name == "pid"}?.value
            projectId = project
        } else {
            componentId = nil
            projectId = nil
        }
    }
}
