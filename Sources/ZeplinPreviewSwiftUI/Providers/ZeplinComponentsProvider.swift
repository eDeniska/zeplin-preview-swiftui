//
//  ZeplinComponentsProvider.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import Combine

final class ZeplinComponentsProvider: ObservableObject {

    @Published private(set) var components: [ZeplinComponent]?

    private var cancellable: AnyCancellable?

    func fetch(accessToken: String, projectId: String) {
        let zeplinProjectId = projectId.removingPercentEncoding ?? projectId

        guard components == nil else {
            return
        }
        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: ZeplinRequestBuilder.componentsRequest(accessToken: accessToken, projectId: zeplinProjectId))
            .map { $0.data }
            .decode(type: [ZeplinComponent].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    print("ZeplinComponentsProvider error: \(error)")
                }
            } receiveValue: { [weak self] components in
                guard let self = self else {
                    return
                }
                self.components = components
            }
    }

}

