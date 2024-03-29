//
//  ZeplinComponentPreview.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import SwiftUI
import Combine


struct ToastView: View {
    @Binding var message: String?

    init(message: Binding<String?>) {
        _message = message
    }

    private func hide() {
        withAnimation {
            message = nil
        }
    }

    var body: some View {
        if let message = message {
            Text(message)
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundColor(Color(UIColor.systemBackground))
                .padding()
                .background(Capsule().fill(Color.primary))
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        hide()
                    }
                }
                .onTapGesture {
                    hide()
                }
        } else {
            EmptyView()
        }
    }
}

extension View {
    @ViewBuilder func toast(_ message: Binding<String?>) -> some View {
        overlay(VStack {
            ToastView(message: message)
            Spacer()
        })
    }
}

struct ZeplinComponentPreview: View {
    private let zeplinComponent: ZeplinComponent
    private let projectId: String

    init(zeplinComponent: ZeplinComponent, projectId: String) {
        self.zeplinComponent = zeplinComponent
        self.projectId = projectId
    }

    @State private var toastMessage: String?
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                ZeplinView(projectId: projectId, componentId: zeplinComponent.id)
                Divider()
                Text(zeplinComponent.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let details = zeplinComponent.details {
                    Text(details)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Button {
                        UIPasteboard.general.string = zeplinComponent.id
                        withAnimation {
                            toastMessage = NSLocalizedString("Component ID is copied to clipboard", bundle: .module, comment: "Component ID is copied to clipboard")
                        }
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .padding()
                    }
                    VStack {
                        Text("Component ID", bundle: .module)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(zeplinComponent.id)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
                HStack {
                    Button {
                        UIPasteboard.general.string = projectId
                        withAnimation {
                            toastMessage = NSLocalizedString("Project ID is copied to clipboard", bundle: .module, comment: "Project ID copied to clipboard")
                        }
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .padding()
                    }
                    VStack {
                        Text("Project ID", bundle: .module)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(projectId)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                }
            }.padding()
        }
        .toast($toastMessage)
        .navigationTitle(zeplinComponent.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
