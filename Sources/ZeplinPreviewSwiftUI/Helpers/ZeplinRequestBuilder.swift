//
//  ZeplinRequestBuilder.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

struct ZeplinRequestBuilder {
    private static let baseURL = "https://api.zeplin.dev/v1"
    private init() {
    }

    static func projectsRequest(accessToken: String) -> URLRequest {
        guard let url = URL(string: "\(baseURL)/projects") else {
            fatalError("could not construct Zeplin Projects request URL")
        }
        return URLRequest(url: url, accessToken: accessToken)
    }

    static func componentsRequest(accessToken: String, projectId: String) -> URLRequest {
        guard let url = URL(string: "\(baseURL)/projects/\(projectId)/components?sort=section") else {
            fatalError("could not construct Zeplin Components request URL for project: \(projectId)")
        }
        return URLRequest(url: url, accessToken: accessToken)
    }

    static func componentRequest(accessToken: String, projectId: String, componentId: String) -> URLRequest {
        guard let url = URL(string: "\(baseURL)/projects/\(projectId)/components/\(componentId)") else {
            fatalError("could not construct Zeplin Component request URL for project: \(projectId), component: \(componentId)")
        }
        return URLRequest(url: url, accessToken: accessToken)
    }
}

extension URLRequest {
    init(url: URL, accessToken: String) {
        self.init(url: url)
        addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
