//
//  CatalogueViewModel.swift
//  2Password
//
//  Created by Ilya Velilyaev on 15/12/2017.
//  Copyright © 2017 Ilya Velilyaev. All rights reserved.
//

import Foundation

final class CatalogueViewModel {

    private var fetcher = DatabaseFetcher()

    var onShowElement: (SavedDataItem) -> Void = { _ in }

    private var supportedTypes: [StoredDataType] = [.login, .creditCard, .note]
    private var cachedItems: [StoredDataType: [SavedDataItem]] = [:]

    func viewWillAppear() {
        refetchItems()
    }

    private func refetchItems() {
        let items = fetcher.fetchCatalogueItems()
        for type in supportedTypes {
            cachedItems[type] = items.filter { $0.dataType == type }
        }
    }

    func numberOfSectionsInCatalogue() -> Int {
        return supportedTypes.count
    }

    func titleForSectionInCatalogue(_ index: Int) -> String {
        return supportedTypes[index].readableType
    }

    func items(in section: Int) -> [SavedDataItem] {
        let type = supportedTypes[section]
        return cachedItems[type] ?? []
    }


}
