//
//  MainTableViewModel.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import Foundation

final class MainTableViewModel: MainTableViewModelProtocol {

    private var networkService: NetworkServiceProtocol
    private var dataModel = [ResponseData]()
    
    var showAlertCallBack: ((String) -> Void)?
    
    var modelIsUpdateCallBack: (() -> Void )? {
        didSet { fetchModel() }
    }
    
    init(with networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func rowCount(in section: Int) -> Int {
        dataModel.count
    }
    
    func cellTypeForRow(at indexPath: IndexPath) -> ResponseDataType {
        getResponseData(at: indexPath)?.type ?? .unknown
    }
    
    func viewModelForPictureCell(at indexPath: IndexPath) -> PictureTableCellViewModelProtocol? {
        guard case .picture(let pictureBlock) = getResponseData(at: indexPath) else { return nil }

        let imageService = ImageService()
        return PictureTableCellViewModel(with: imageService, text: pictureBlock.text, pictureURLString: pictureBlock.urlString)
    }
    
    func viewModelForTextCell(at indexPath: IndexPath) -> TextTableCellViewModelProtocol? {
        guard case .hz(let textBlock) = getResponseData(at: indexPath) else { return nil }

        return TextTableCellViewModel(with: textBlock.text)
    }
    
    func viewModelForSelectorCell(at indexPath: IndexPath) -> SelectorTableCellViewModelProtocol? {
        guard case .selector(let selectorBlock) = getResponseData(at: indexPath) else { return nil }
        
        let viewModel = SelectorTableCellViewModel(selectorBlock.selectedId, selectorBlock.variants)
        viewModel.delegate = self
        return viewModel
    }
    
    func viewModelForVideoCell(at indexPath: IndexPath) -> VideoTableCellViewModelProtocol? {
        guard case .video(let videoModel) = getResponseData(at: indexPath) else { return nil }
        return VideoTableCellViewModel(model: videoModel)
    }
    
    func viewModelForAudioCell(at indexPath: IndexPath) -> AudioTableCellViewModelProtocol? {
        guard case .audio(let audioModel) = getResponseData(at: indexPath) else { return nil }
        return AudioTableCellViewModel(model: audioModel)
    }
    
    func didTapRow(at indexPath: IndexPath) {
        guard let responseData = getResponseData(at: indexPath) else { return }
        var typeText: String = responseData.type.rawValue + " "
        
        switch responseData {
        case .picture(let pictureModel):
            typeText += pictureModel.text
        case .selector(let selectorModel):
            typeText += String(selectorModel.selectedId)
        case .hz(let textModel):
            typeText += textModel.text
        case .audio(let audioModel):
            typeText += audioModel.text
        case .video(let videoModel):
            typeText += videoModel.text
        case .unknown:
            break
        }
        
        showAlertCallBack?(typeText)
    }
    
    private func fetchModel() {
        networkService.fetch(urlString: NetworkService.Constants.customData) { [weak self] result in
            switch result {
            case .success(let response):
                self?.sortedModel(with: response)
                self?.modelIsUpdateCallBack?()
            case .failure(let error): print(error)
            }
        }
    }
    
    private func getResponseData(at indexPath: IndexPath) -> ResponseData? {
        guard dataModel.count > indexPath.row else { return nil }
        return dataModel[indexPath.row]
    }
    
    func sortedModel(with response: PryanikyServerResponse) {
        let viewModel = response.view
        let tempDataModel = response.data
        
        var pictures = [ResponseData]()
        var selectors = [ResponseData]()
        var texts = [ResponseData]()
        var audios = [ResponseData]()
        var videos = [ResponseData]()
        
        var pictureCounter = 0
        var selectorCounter = 0
        var textCounter = 0
        var audioCounter = 0
        var videoCounter = 0
        
        for data in tempDataModel {
            switch data {
            case .selector: selectors.append(data)
            case .picture: pictures.append(data)
            case .hz: texts.append(data)
            case .audio: audios.append(data)
            case .video: videos.append(data)
            case .unknown: continue
            }
        }
        
        for view in viewModel {
            
            switch view {
            case .picture:
                if pictureCounter >= pictures.count {
                    pictureCounter = 0
                }
                self.dataModel.append(pictures[pictureCounter])
                pictureCounter += 1
                
            case .hz:
                if textCounter >= texts.count {
                    textCounter = 0
                }
                self.dataModel.append(texts[textCounter])
                textCounter += 1
                
            case .selector:
                if selectorCounter >= selectors.count {
                    selectorCounter = 0
                }
                self.dataModel.append(selectors[selectorCounter])
                selectorCounter += 1
            case .audio:
                if audioCounter >= audios.count {
                    audioCounter = 0
                }
                self.dataModel.append(audios[audioCounter])
                audioCounter += 1
            case .video:
                if videoCounter >= videos.count {
                    videoCounter = 0
                }
                self.dataModel.append(videos[videoCounter])
                videoCounter += 1
            case .unknown: continue
            }
        }
    }
}

extension MainTableViewModel: SelectorTableCellViewModelDelegate {
    
    func selectorTableCellViewModelDidChange(selectId: Int, text: String) {
        showAlertCallBack?("\(ResponseDataType.selector.rawValue): id(\(String(selectId))) - \(text)")
        
    }
}
