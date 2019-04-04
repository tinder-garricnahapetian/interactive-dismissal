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

    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Push", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapPush(button:)), for: .touchUpInside)
        return button
    }()

    private var contentOffsetYAtTop: CGFloat?
    private var isAtTopOrBeyond: Bool {
        if let contentOffsetYAtTop = contentOffsetYAtTop {
            return tableView.contentOffset.y <= contentOffsetYAtTop
        } else {
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addPanGesture()
        addTableView()
//        addPushButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentOffsetYAtTop = tableView.contentOffset.y
    }

    var didTapPush: (() -> Void)?

    @objc
    private func didTapPush(button: UIButton) {
        didTapPush?()
    }

    private func addPushButton() {
        view.addSubview(button)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func addPanGesture() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(didPan(gesture:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }

    @objc
    private func didPan(gesture: UIPanGestureRecognizer) {
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
        cell.textLabel?.text = "Push"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapPush?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ContentViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
