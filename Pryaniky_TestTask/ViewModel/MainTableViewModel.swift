//
//  MainTableViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

final class MainTableViewModel: MainTableViewModelProtocol {

    private var networkService: NetworkServiceProtocol
    private var model: PryanikiResponse?
    
    var modelIsUpdateCallBack: (() -> Void )? {
        didSet { fetchModel() }
    }
    
    init(with networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func rowCount(in section: Int) -> Int {
        model?.view?.count ?? 0
    }
    
    func cellTypeForRow(at indexPath: IndexPath) -> MainTableCellType? {

        guard let responseTypeData = getResponseTypeData(at: indexPath) else { return nil }

        if responseTypeData.text == nil { return .selector }
        if responseTypeData.text != nil, responseTypeData.url != nil { return .picture }
        if responseTypeData.text != nil, responseTypeData.url == nil { return .unknown }

        return nil
    }
    
    func viewModelForPictureCell(at indexPath: IndexPath) -> PictureTableCellViewModelProtocol? {
        guard let responseTypeData = getResponseTypeData(at: indexPath),
              let text = responseTypeData.text, let urlString = responseTypeData.url else { return nil }
        
        let imageService = ImageService()
        return PictureTableCellViewModel(with: imageService, text: text, pictureURLString: urlString)
    }
    
    func viewModelForTextCell(at indexPath: IndexPath) -> TextTableCellViewModelProtocol? {
        guard let responseTypeData = getResponseTypeData(at: indexPath),
              let text = responseTypeData.text else { return nil }

        return TextTableCellViewModel(with: text)
    }
    
    func viewModelForSelectorCell(at indexPath: IndexPath) -> SelectorTableCellViewModelProtocol? {
        guard let responseTypeData = getResponseTypeData(at: indexPath),
              let startIndex = responseTypeData.selectedId,
              let variants = responseTypeData.variants else { return nil}
        
        return SelectorTableCellViewModel(startIndex, variants)
    }
    
    func didTapRow(at indexPath: IndexPath) {
        guard let views = model?.view,
              indexPath.row < views.count,
              let responseType = model?.data?.first(where: { $0.name == views[indexPath.row] }) else { return }
        print(responseType.name!)
    }
    
    private func fetchModel() {
        networkService.fetch { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                self?.modelIsUpdateCallBack?()
                print("CALLBACK DONE")
            case .failure(let error): print(error)
            }
        }
    }
    
    private func getResponseTypeData(at indexPath: IndexPath) -> SomeData? {
        guard let views = model?.view,
              indexPath.row < views.count else { return nil }
        
        return model?.data?.first(where: { $0.name == views[indexPath.row] })?.data
    }
    
}
