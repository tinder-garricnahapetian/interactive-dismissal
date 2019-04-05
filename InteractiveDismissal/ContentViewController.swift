//
//  ContentViewController.swift
//  InteractiveDismissal
//
//  Created by Garric Nahapetian on 4/3/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

final class ContentViewController: UIViewController {

    let tableView: UITableView = .init()

    var didTapPushStaticView: (() -> Void)?
    var didTapPushTableView: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addTableView()
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource

extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        let cell = dequeuedCell ?? UITableViewCell.init(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = indexPath.row % 2 == 0 ? "Push Static View" : "Push Table View"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            didTapPushStaticView?()
        } else {
            didTapPushTableView?()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
