//
//  ViewController.swift
//  SilentPushTest
//
//  Created by Daniel Hjärtström on 2019-11-27.
//  Copyright © 2019 Daniel Hjärtström. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var items = [Person]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        temp.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        view.backgroundColor = .white
        registerCells()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    @objc private func fetchData() {
        Core.shared.fetch(type: Person.self) { [weak self] people in
            self?.items = people
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func registerCells() {
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: "PersonTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as? PersonTableViewCell else { return UITableViewCell() }
        let person = items[indexPath.row] 
        cell.configure(person)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = items[indexPath.row]
        let vc = PersonDetailViewController()
        vc.person = person
        navigationController?.pushViewController(vc, animated: true)
        person.markAsRead()
        UIApplication.decreaseBadgeNumberBy(1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}
