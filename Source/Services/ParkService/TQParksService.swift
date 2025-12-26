//
// TQParksService.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

final class TQParksService: TQParksServiceProtocol {
    private let decoder: JSONDecoder
    private let bundle: Bundle
    private let resourceName: String

    init(
        decoder: JSONDecoder = JSONDecoder(),
        bundle: Bundle = TQBundleHelper.bundle,
        resourceName: String = "parks"
    ) {
        self.decoder = decoder
        self.bundle = bundle
        self.resourceName = resourceName
    }

    func getParks() async -> TQState<[TQPark]> {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            log(error: .fileNotFound)
            return .failure
        }

        do {
            let data = try Data(contentsOf: url)
            let parksData = try decoder.decode(TQParksData.self, from: data)
            return .result(parksData.parks)
        } catch let decodingError as DecodingError {
            log(error: .decodingFailed(decodingError))
            return .failure
        } catch {
            log(error: .dataLoadingFailed(error))
            return .failure
        }
    }

    private func log(error: TQParksServiceError) {
        debugPrint("TQParksService error: \(error.localizedDescription)")
    }
}
