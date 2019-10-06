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

    private let networkCLient = DefaultMoyaNetworkClient()
    private let dateFormatter = DateFormatter()
    private var facts = [Fact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAnimalFactsUseFutureRequestChain()
    }

    // MARK: Private Methods
    private func getCatFacts() {
        networkCLient.request(NewsAPI.catFacts) { [weak self] (result: Result<[Fact]>) in
            switch result {
            case let .success(facts):
                self?.facts = facts
                self?.tableView.reloadData()
            case let .failure(error):
                self?.showError(with: error.localizedDescription)
            }
        }
    }

    private func getAnimalFactsUseFutureRequestChain() {
        networkCLient.request(NewsAPI.catFacts, cachePolicy: .reloadIgnoringCacheData)
            .flatMapSuccess { [weak self] (facts: [Fact]) -> FutureResult<[Fact]>? in
                self?.facts.append(contentsOf: facts)
                return self?.networkCLient.request(NewsAPI.dogFacts)
            }
            .observeSuccess { [weak self] facts in
                self?.facts.append(contentsOf: facts)
                self?.tableView.reloadData()
            }
            .observeError { [weak self] error in self?.showError(with: error.localizedDescription) }
            .execute()
    }

    private func showError(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
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
