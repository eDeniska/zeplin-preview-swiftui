//
//  ZeplinProjectsProvider.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 21.05.2021.
//

import Foundation
import Combine

final class ZeplinProjectsProvider: ObservableObject {

    @Published private(set) var projects: [ZeplinProject]?

    private var cancellable: AnyCancellable?

    func fetch(accessToken: String) {
        guard projects == nil else {
            return
        }
        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: ZeplinRequestBuilder.projectsRequest(accessToken: accessToken))
            .map { $0.data }
            .decode(type: [ZeplinProject].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    print("ZeplinProjectsProvider error: \(error)")
                }
            } receiveValue: { [weak self] projects in
                guard let self = self else {
                    return
                }
                self.projects = projects.filter(\.isActive)
            }
    }

}

