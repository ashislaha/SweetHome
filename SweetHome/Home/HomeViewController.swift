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
       
        add(childView: homeView)
        initialiseHome()
    }

    @IBAction private func searchTapped(_ sender: UIButton) {
        
    }
    @IBAction private func listTapped(_ sender: UIButton) {
        
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
        
        // remove the older one
        switch currentSelectedOption {
        case .collection:
            delete(childView: homeView)
        case .duplicate:
            print("load the duplicates")
        case .favourites:
            print("favourites")
        case .missing:
            print("open missing")
        case .myHouse:
            print("my house")
        }
        
        // add new view
        switch option {
        case .collection:
            add(childView: homeView)
            initialiseHome()
        case .duplicate:
            print("load the duplicates")
        case .favourites:
            print("favourites")
        case .missing:
            print("open missing")
        case .myHouse:
            print("my house")
        }
        currentSelectedOption = option
    }
}
