//
//  HomeViewController.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/17/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak private var container: UIView!
    @IBOutlet weak private var listButtonOutlet: UIButton!
    @IBOutlet weak private var optionsView: UserPreferanceView! {
        didSet {
            optionsView.delegate = self
        }
    }
    
    // container views
    private let homeView: HomesView = {
        let view = HomesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var currentSelectedOption: Options = .collection
    private let dataService = DataServiceProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        homeView.delegate = self
        add(childView: homeView)
        initialiseHome()
    }
    
    // MARK:- initialise home
    private func initialiseHome() {
        do {
            try dataService.getPhotos(params: ["text": "HOUSE"]) { [weak self] (photos) in
                self?.homeView.photos = photos
            }
        } catch let error {
            print(error)
        }
    }
    
    // MARK:- Handle container
    private func add(childView: UIView) {
        container.addSubview(childView)
        childView.fillSuperView()
    }
    
    private func delete(childView: UIView) {
        childView.removeFromSuperview()
    }
}

extension HomeViewController: UserPreferanceViewProtocol {
    func optionSelected(_ option: Options) {
        guard currentSelectedOption != option else { return }
        performOps(currentSelectedOption, isRemoving: true) // remove the older one
        performOps(option, isRemoving: false) // add new view
        currentSelectedOption = option
    }
    private func performOps(_ option: Options, isRemoving: Bool = false) {
        switch option {
        case .collection:
            if isRemoving {
                delete(childView: homeView)
            } else {
                add(childView: homeView)
                initialiseHome()
            }
        case .duplicate: break
        case .favourites: break
        case .missing: break
        case .myHouse: break
        }
    }
}

extension HomeViewController: HomesViewProtocol {
    func selectHome(_ model: Photo) {
        
        guard let homeDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeDetailsViewController") as? HomeDetailsViewController else { return }
        
        let navigationVC = UINavigationController(rootViewController: homeDetailsVC)
        present(navigationVC, animated: true, completion: nil)
    }
}
