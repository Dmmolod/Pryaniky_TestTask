//
//  MainTableViewController.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import UIKit

final class MainTableViewController: UIViewController {
    
    var viewModel: MainTableViewModelProtocol
    
    private var tableView: UITableView = {
       let table = UITableView()
        table.separatorStyle = .none
        table.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
        table.register(PictureTableViewCell.self, forCellReuseIdentifier: PictureTableViewCell.identifier)
        table.register(SelectorTableViewCell.self, forCellReuseIdentifier: SelectorTableViewCell.identifier)
        return table
    }()
    
    init(with viewModel: MainTableViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        bind()
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func bind() {
        viewModel.modelIsUpdateCallBack = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.showAlertCallBack = { [weak self] alertText in
            let alertVC = UIAlertController(title: "", message: alertText, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { _ in
                alertVC.dismiss(animated: true)
            }))
            self?.present(alertVC, animated: true)
        }
    }
}

extension MainTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        switch viewModel.cellTypeForRow(at: indexPath) {
        case .picture:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: PictureTableViewCell.identifier,
                                                         for: indexPath) as? PictureTableViewCell
            tempCell?.viewModel = viewModel.viewModelForPictureCell(at: indexPath)
            tempCell?.bind()
            cell = tempCell
            
        case .unknown:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier,
                                                         for: indexPath) as? TextTableViewCell

            tempCell?.viewModel = viewModel.viewModelForTextCell(at: indexPath)
            tempCell?.bind()
            cell = tempCell
        case .selector:
            let tempCell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier,
                                                         for: indexPath) as? SelectorTableViewCell
            tempCell?.viewModel = viewModel.viewModelForSelectorCell(at: indexPath)
            tempCell?.bind()
            cell = tempCell
            
        default: break
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.cellTypeForRow(at: indexPath) {
        case .unknown: return tableView.estimatedRowHeight
        case .selector: return 100
        case .picture: return 200
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didTapRow(at: indexPath)
    }
}
