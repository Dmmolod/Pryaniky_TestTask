//
//  MainTableViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

final class MainTableViewModel: MainTableViewModelProtocol {

    private var networkService: NetworkServiceProtocol
    private var model: ServerResponse?
    
    var showAlertCallBack: ((String) -> Void)?
    
    var modelIsUpdateCallBack: (() -> Void )? {
        didSet { fetchModel() }
    }
    
    init(with networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func rowCount(in section: Int) -> Int {
        model?.view.count ?? 0
    }
    
    func cellTypeForRow(at indexPath: IndexPath) -> ResponseData {
        getResponseData(at: indexPath) ?? .unknown
    }
    
    func viewModelForPictureCell(at indexPath: IndexPath) -> PictureTableCellViewModelProtocol? {
        guard case .picture(let pictureBlock) = getResponseData(at: indexPath) else { return nil }
        
        let imageService = ImageService()
        return PictureTableCellViewModel(with: imageService, text: pictureBlock.data.text, pictureURLString: pictureBlock.data.url)
    }
    
    func viewModelForTextCell(at indexPath: IndexPath) -> TextTableCellViewModelProtocol? {
        guard case .hz(let textBlock) = getResponseData(at: indexPath) else { return nil }

        return TextTableCellViewModel(with: textBlock.data.text)
    }
    
    func viewModelForSelectorCell(at indexPath: IndexPath) -> SelectorTableCellViewModelProtocol? {
        guard case .selector(let selectorBlock) = getResponseData(at: indexPath) else { return nil }
        
        let viewModel = SelectorTableCellViewModel(selectorBlock.data.selectedId, selectorBlock.data.variants)
        viewModel.delegate = self
        return viewModel
    }
    
    func didTapRow(at indexPath: IndexPath) {
        guard let responseData = getResponseData(at: indexPath) else { return }
        let typeText: String
        
        switch responseData {
        case .picture(let pictureBlock): typeText = pictureBlock.name
        case .selector(let selectorBlock): typeText = selectorBlock.name
        case .hz(let textBlock): typeText = textBlock.name
        case .unknown: return
        }
        
        showAlertCallBack?(typeText)
    }
    
    private func fetchModel() {
        networkService.fetch { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
                self?.modelIsUpdateCallBack?()
            case .failure(let error): print(error)
            }
        }
    }
    
    private func getResponseData(at indexPath: IndexPath) -> ResponseData? {
        guard let model = model, model.view.count > indexPath.row else { return nil }
        let type = ResponseDataType(rawValue: model.view[indexPath.row])
        let responseData = model.data.first(where: { $0.type == type })
        return responseData
    }
}

extension MainTableViewModel: SelectorTableCellViewModelDelegate {
    
    func selectorTableCellViewModelDidChange(selectId: Int, text: String) {
        showAlertCallBack?("\(ResponseDataType.selector.rawValue): id(\(String(selectId))) - \(text)")
    }
}
