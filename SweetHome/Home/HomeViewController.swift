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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction private func searchTapped(_ sender: UIButton) {
        
    }
    @IBAction private func listTapped(_ sender: UIButton) {
        
    }
}

extension HomeViewController: UserPreferanceViewProtocol {
    func optionSelected(_ option: Options) {
        switch option {
        case .collection:
            print("load collection of homes")
        case .duplicate:
            print("load the duplicates")
        case .favourites:
            print("favourites")
        case .missing:
            print("open missing")
        case .myHouse:
            print("my house")
        }
    }
}
