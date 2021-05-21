//
//  ZeplinComponentsList.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI

extension ZeplinComponent: Identifiable { }

public struct ZeplinComponentsList {
    private let passedProjectId: String?

    public init() {
        passedProjectId = nil
    }

    public init(projectId: String) {
        passedProjectId = projectId
    }

    public init(link: String) {
        passedProjectId = ZeplinLinkParser(link: link).projectId
    }

    var body: some View {
        NavigationView {
            ZeplinComponentsListInner(projectId: passedProjectId)
        }
    }
}

struct ZeplinComponentsListInner: View {

    private let passedProjectId: String?

    private var projectId: String {
        passedProjectId ?? zeplinProjectId
    }

    @Environment(\.zeplinAccessToken) private var zeplinAccessToken
    @Environment(\.zeplinProjectId) private var zeplinProjectId
    @StateObject private var componentsProvider = ZeplinComponentsProvider()

    init(projectId: String? = nil) {
        passedProjectId = projectId
    }

    public var body: some View {
        Group {
            if let components = componentsProvider.components {
                if components.isEmpty {
                    // empty view state
                    Text("No components found", bundle: .module).font(.headline)
                } else {
                    List(components) { component in
                        NavigationLink(destination: ZeplinComponentPreview(zeplinComponent: component, projectId: projectId)) {
                            HStack {
                                RemoteImage(link: component.image.thumbnails.small)
                                    .frame(width: 64, height: 64, alignment: .center)
                                VStack {
                                    Text(component.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if let details = component.details {
                                        Text(details)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        componentsProvider.fetch(accessToken: zeplinAccessToken, projectId: projectId)
                    }
            }
        }.navigationTitle(Text("Components", bundle: .module))
    }
}
