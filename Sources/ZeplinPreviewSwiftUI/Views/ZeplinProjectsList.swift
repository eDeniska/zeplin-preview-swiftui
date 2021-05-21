//
//  ZeplinProjectsList.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 21.05.2021.
//

import SwiftUI

extension ZeplinProject: Identifiable { }

public struct ZeplinProjectsList: View {

    @Environment(\.zeplinAccessToken) private var zeplinAccessToken

    @StateObject private var projectsProvider = ZeplinProjectsProvider()

    public init() {
    }

    public var body: some View {
        NavigationView {
            Group {
            if let projects = projectsProvider.projects {
                if projects.isEmpty {
                    // empty view state
                    Text("No projects found", bundle: .module).font(.headline)
                } else {
                    List(projects) { project in
                        NavigationLink(destination: ZeplinComponentsListInner(projectId: project.id)) {
                            HStack {
                                RemoteImage(link: project.thumbnailLink)
                                    .frame(width: 96, height: 96, alignment: .center)
                                VStack(spacing: 8) {
                                    Text(project.title)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if let details = project.details {
                                        Text(details)
                                            .lineLimit(2)
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Text("Components: \(project.componentCount)", bundle: .module)
                                        .font(.footnote)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                }
                            }
                        }
                    }
                }

            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        projectsProvider.fetch(accessToken: zeplinAccessToken)
                    }
            }
            }.navigationTitle(Text("Projects", bundle: .module))
        }
    }
}
