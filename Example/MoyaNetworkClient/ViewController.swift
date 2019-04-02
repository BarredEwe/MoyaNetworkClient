//
//  ViewController.swift
//  MoyaNetworkClient
//
//  Created by BarredEwe on 04/02/2019.
//  Copyright (c) 2019 BarredEwe. All rights reserved.
//

import UIKit
import MoyaNetworkClient

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let networkCLient = MoyaNetworkClient<CustomError>()
    private var facts = [Fact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getCatFacts { [weak self] result in
            switch result {
            case let .success(facts):
                self?.facts = facts
                self?.tableView.reloadData()
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    private func getCatFacts(completion: @escaping Completion<[Fact]>) {
        networkCLient.request(NewsAPI.catFacts, completion)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FactTableViewCell") as? FactTableViewCell else { return UITableViewCell() }
        cell.factLabel.text = facts[indexPath.row].text
        return cell
    }
}

extension ViewController: UITableViewDelegate { }
