//
//  MainViewNavigationBar.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import UIKit

class MainViewNavigationBar: UIView {
    private let NIB_NAME = "MainViewNavigationBar"
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var view: UIView!
    
    var searchDelegate: UISearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nib = UINib.init(nibName: NIB_NAME, bundle: nil)
        let mView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        mView.frame = frame
        customSubViews()
        addSubview(mView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    private func customSubViews() {
        filterButton.addBorderLightGray(width: 1)
        
        searchBar.delegate = self
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.borderColor = ATColor.universalBorderLightGrey
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.textAlignment = .left
        searchBar.searchTextField.placeholder = "Search for a restaurant"
    }
}

extension MainViewNavigationBar: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText == "" {
            searchBar.searchTextField.resignFirstResponder()
            searchBar.endEditing(true)
        }
    }
}
