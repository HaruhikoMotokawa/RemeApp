//
//  SalesFloorShoppingListViewController.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/02.
//

import UIKit

class SalesFloorShoppingListViewController: UIViewController {

    @IBOutlet weak var salesFloorShoppingListTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
}

extension SalesFloorShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

extension SalesFloorShoppingListViewController: UITableViewDelegate {
    
}
