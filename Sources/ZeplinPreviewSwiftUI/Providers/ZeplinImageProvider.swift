//
//  ZeplinImageProvider.swift
//  ZeplinPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import Combine
import SwiftUI


enum ZeplinImageError: Error {
    case noImageURL
    case badImageData
}

final class ZeplinImageProvider: ObservableObject {

    private static var imageCache = ImageCache(size: 32 * 1024 * 1024)

    private static func key(projectId: String, componentId: String) -> String {
        "\(projectId)/\(componentId)"
    }

    @Published private(set) var image: Image?

    private var cancellable: AnyCancellable?

    func fetch(accessToken: String, projectId: String, componentId: String) {
        let zeplinProjectId = projectId.removingPercentEncoding ?? projectId
        let zeplinComponentId = componentId.removingPercentEncoding ?? componentId

        guard image == nil else {
            return
        }

        if let image = Self.imageCache[Self.key(projectId: zeplinProjectId, componentId: zeplinComponentId)] {
            self.image = Image(uiImage: image)
            return
        }

        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: ZeplinRequestBuilder.componentRequest(accessToken: accessToken, projectId: zeplinProjectId, componentId: zeplinComponentId))
            .mapError { $0 as Error }
            .map {
                print("----> \(String(data: $0.data, encoding: .utf8)!)")
                return $0.data
            }
            .decode(type: ZeplinComponent.self, decoder: JSONDecoder())
            .flatMap { component -> AnyPublisher<UIImage, Error> in
                guard let imageURL = URL(string: component.image.imageLink) else {
                    return Fail<UIImage, Error>(error: ZeplinImageError.noImageURL).eraseToAnyPublisher()
                }

                return URLSession.shared.dataTaskPublisher(for: imageURL)
                    .mapError { $0 as Error }
                    .map { $0.data }
                    .tryMap { data in
                        guard let image = UIImage(data: data) else {
                            throw ZeplinImageError.badImageData
                        }

                        return image
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    break

                case .failure(let error):
                    print("ZeplinImageProvider error: \(error)")
                    self.image = Image(systemName: "rectangle.badge.xmark")
                }
            } receiveValue: { [weak self] image in
                guard let self = self else {
                    return
                }
                self.image = Image(uiImage: image)
                Self.imageCache[Self.key(projectId: zeplinProjectId, componentId: zeplinComponentId)] = image
            }
    }

}
