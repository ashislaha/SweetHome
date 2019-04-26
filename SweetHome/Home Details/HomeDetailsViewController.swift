//
//  HomeDetailsViewController.swift
//  SweetHome
//
//  Created by Ashis Laha on 4/25/19.
//  Copyright © 2019 Team A. All rights reserved.
//

import UIKit

enum HomeDetailsCellType: Int {
    case image = 0
    case description
    case video
    case map
    case note
    
    func getCellId() -> String {
        switch self {
        case .image: return "image"
        case .description: return "description"
        case .video: return "video"
        case .map: return "map"
        case .note: return "note"
        }
    }
}

class HomeDetailsViewController: UIViewController {
    
    private let cellTypes: [HomeDetailsCellType] = [.image, .description, .video, .map, .note]
    private var model: HomeDetails?
    
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "HomeDetailsImageTableViewCell", bundle: nil), forCellReuseIdentifier: HomeDetailsCellType.image.getCellId())
            tableView.register(UINib(nibName: "HomeDetailsDesciptionTableViewCell", bundle: nil), forCellReuseIdentifier: HomeDetailsCellType.description.getCellId())
            tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: HomeDetailsCellType.video.getCellId())
            
            // resize based on content
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCloseButton()
        getHomeDetails()
        title = "Home Details"
    }
    private func getHomeDetails() {
        let dataServiceProvider = DataServiceProvider()
        dataServiceProvider.getHomeDetails { [weak self] (homeDetails) in
            self?.model = homeDetails
            self?.tableView.reloadData()
        }
    }
    private func addCloseButton() {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // on tap of video, play/pause it
    }
}

// MARK:- UITableViewDataSource
extension HomeDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = HomeDetailsCellType(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch cellType {
        case .image:
            guard let imageCell = tableView.dequeueReusableCell(withIdentifier: HomeDetailsCellType.image.getCellId(), for: indexPath) as? HomeDetailsImageTableViewCell else { return UITableViewCell() }
            imageCell.images = model?.images ?? []
            return imageCell
            
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailsCellType.description.getCellId(), for: indexPath) as? HomeDetailsDesciptionTableViewCell else { return UITableViewCell() }
            cell.desc = model?.description
            return cell
            
        case .video:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDetailsCellType.video.getCellId(), for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
            cell.videoUrl = model?.videoUrl
            return cell
            
        case .map: break
            
        case .note: break
        }
        return UITableViewCell()
    }
}
