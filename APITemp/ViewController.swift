//
//  ViewController.swift
//  APITemp
//
//  Created by Rukmani  on 13/07/17.
//  Copyright © 2017 rukmani. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var tableView = UITableView()
    var data = [String]()
    let controller = Controller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.gray
        tableView.frame = CGRect(x: 10, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        self.view.addSubview(tableView)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTitles))
        self.navigationItem.rightBarButtonItem = deleteButton
        self.automaticallyAdjustsScrollViewInsets = true
        fetchTitles()
        if self.data.count == 0 {
            controller.delegate = self as CompletionHandler
            controller.getMovies(completed: { list in
                self.data = list
                self.saveTitles()
                self.tableView.reloadData()
            })
        }
    }
    
    func saveTitles() {
        for title in self.data {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Title", into: context)
            entity.setValue(title, forKey: "title")
            do {
                try context.save()
            } catch(let err) {
                print(err)
            }
        }
    }
    
    func fetchTitles() {
        self.data.removeAll()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Title")
        do {
            let titles = try context.fetch(fetchRequest) as! [Title]
            for title in titles {
                let value = title.value(forKey: "title") as! String
                self.data.append(value)
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func deleteTitles() {
        self.data.removeAll()
        self.tableView.reloadData()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Title")
        do {
           let result = try context.fetch(fetchRequest) as! [Title]
            if result.count > 0 {
                for title in result {
                    context.delete(title as NSManagedObject)
                }
            }
            try context.save()
        }catch {
            
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
            cell.textLabel?.text = data[indexPath.row]
            return cell
        }
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

extension ViewController: CompletionHandler {
    func onCompletion(list: [String]) {
        self.data = list
        tableView.reloadData()
    }
}



