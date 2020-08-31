//
//  Task3ViewController.swift
//  lesson_3
//
//  Created by Oleksandr Karpenko on 31.08.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Bond

class Task3ViewController: UIViewController {
    
    let names = MutableObservableArray(["Alex", "Oleg", "Max", "Tanya"])
    
    @IBOutlet weak var addNewNameButton: UIButton!
    @IBOutlet weak var removeLastNameButton: UIButton!
    @IBOutlet weak var namesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        names.bind(to: namesTable) { (dataSource, indexPath, tableView) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell") as! NameTableViewCell
            
            cell.nameLabel.text = dataSource[indexPath.row]
            
            return cell
        }.dispose(in: reactive.bag)
        
        addNewNameButton.reactive.tap.observeNext {
            self.names.insert("New name", at: 0)
        }.dispose(in: reactive.bag)
        
        removeLastNameButton.reactive.tap.observeNext {
            if self.names.count != 0 {
                self.names.remove(at: self.names.count-1)
            }
        }.dispose(in: reactive.bag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactive.bag.dispose()
    }
    
}
