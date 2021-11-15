//
//  ListViewController.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import UIKit
import RxSwift
import RxDataSources

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var lViewModel: MainViewControllerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        bindData()
    }
    
    private func bindData() {
        let dataSource = RxTableViewSectionedReloadDataSource<ListSectionModel> { dataSource, tableView, indexPath, item in
            switch item.cellIdentyfier {
            case .listCellIdentifier:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentyfier.identifier, for: indexPath) as? ListTableViewCell else {
                    return UITableViewCell()
                }
                cell.setupCell(model: item)
                return cell
            }
        }
        
        lViewModel?.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe {[weak self] indexPath in
                self?.showRestaurantDetailViewController(item: dataSource[indexPath])
            }
            .disposed(by: disposeBag)
            
    }
}
