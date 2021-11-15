//
//  ViewController.swift
//  ATRestaurants
//
//  Created by Yangbin Wen on 11/12/21.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    @Inject var locationManager: ATLocationManager
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewControllerViewModel()
    private let containerView = UIView()
    private let topView = MainViewNavigationBar()
    private let changeViewButton = UIButton()
    private var listController = ListViewController()
    private var mapController = MapViewController()
    private let indicator = UIActivityIndicatorView(style: .large)
    private let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    private let listVCId = "ListViewController"
    private let mapVCId = "MapViewController"
    
    private var showList = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listController = storyBoard.instantiateViewController(withIdentifier: listVCId) as! ListViewController
        listController.lViewModel = viewModel
        mapController.mViewModel = viewModel
        mapController.keyboardDelegate = self
        bindData()
        setupView()
        switchChildControllers()
        definesPresentationContext = true
    }

    private func setupView() {
        view.addSubview(topView)
        navigationController?.navigationBar.isHidden = true
        topView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topView)
        NSLayoutConstraint.activate(
            [
                topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                topView.heightAnchor.constraint(equalToConstant: 80)
            ]
        )
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
                containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
        
        view.addSubview(changeViewButton)
        setButtonAppearance()
        changeViewButton.superview?.bringSubviewToFront(changeViewButton)
        changeViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                changeViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                changeViewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ]
        )
        
        view.addSubview(indicator)
        indicator.superview?.bringSubviewToFront(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
    private func bindData() {
        locationManager.currentLocation
            .subscribe (onNext: {[unowned self] status in
                switch status {
                case .auth(let loc):
                    self.viewModel.getNearbyRestaurants(lat: loc.coordinate.latitude, long: loc.coordinate.longitude, name: nil)
                case .noAuth:
                    self.showAlertMessage(titleStr: LocalDescriptions.LocationAccessError, messageStr: LocalDescriptions.LocationAccessMessage)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        viewModel.restaurantsBehaviorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] status in
                switch status {
                case .loading:
                    self.indicator.isHidden = false
                    self.indicator.startAnimating()
                default:
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        changeViewButton.rx
            .tap
            .subscribe {[unowned self] _ in
                self.showList = !self.showList
                self.setButtonAppearance()
                self.switchChildControllers()
            }
            .disposed(by: disposeBag)

        topView.searchBar
            .rx
            .text
            .orEmpty // make it unoptional
            .debounce(.seconds(1), scheduler: MainScheduler.instance) // Wait 1s for changes.
            .skip(1)
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .subscribe(onNext: { [unowned self] inputText in
                guard let lat = locationManager.currentLoc?.coordinate.latitude,
                      let long = locationManager.currentLoc?.coordinate.longitude else {
                          return
                      }
                self.viewModel.getNearbyRestaurants(lat: lat, long: long, name: inputText.count > 0 ? inputText : nil)
                self.topView.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

extension MainViewController {
    private func setButtonAppearance() {
        changeViewButton.setTitle( showList ? "Map" : "List", for: .normal)
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.image = UIImage(systemName: showList ? "pin.fill" : "list.bullet")
        changeViewButton.configuration = buttonConfig
    }
     
    private func switchChildControllers() {
        removeChildController(controller: showList ? mapController : listController)
        addChildController(controller: showList ? listController : mapController)
    }
    
    private func addChildController(controller: UIViewController) {
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.view.frame = containerView.bounds
        controller.didMove(toParent: self)
    }
    
    private func removeChildController(controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
}

extension MainViewController: DismissKeyboardWhenMoveOnMap {
    func shouldDideKeyboard(hide: Bool) {
        topView.searchBar.endEditing(hide)
    }
}
