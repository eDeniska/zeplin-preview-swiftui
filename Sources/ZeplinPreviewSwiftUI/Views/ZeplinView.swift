//
//  ZeplinView.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

public struct ZeplinView: View {
    private let passedProjectId: String?
    private let componentId: String

    private var projectId: String {
        passedProjectId ?? zeplinProjectId
    }

    @Environment(\.zeplinAccessToken) private var zeplinAccessToken
    @Environment(\.zeplinProjectId) private var zeplinProjectId
    @StateObject private var imageProvider = ZeplinImageProvider()

    public init(link: String) {
        let parser = ZeplinLinkParser(link: link)
        componentId = parser.componentId ?? ""
        passedProjectId = parser.projectId
    }

    public init(projectId: String? = nil, componentId: String) {
        self.passedProjectId = projectId
        self.componentId = componentId
    }

    public var body: some View {
        if let image = imageProvider.image {
            image
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    imageProvider.fetch(accessToken: zeplinAccessToken, projectId: projectId, componentId: componentId)
                }
        }
    }
}
