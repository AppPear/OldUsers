//
//  MasterViewController.swift
//  OldUsers
//
//  Created by Samu András on 2019. 09. 17..
//  Copyright © 2019. Samu András. All rights reserved.
//

import UIKit
import Kingfisher
class MasterViewController: UITableViewController, UsersDelegate {
  
  var detailViewController: DetailViewController? = nil
  var users: Users = Users()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    users.delegate = self
    navigationItem.leftBarButtonItem = editButtonItem
    navigationController?.navigationBar.prefersLargeTitles = true
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: nil)
    self.refreshControl?.addTarget(self, action: #selector(self.refreshTable), for: .valueChanged)
    if let refresh = self.refreshControl {
      self.tableView.addSubview(refresh)
    }
    if let split = splitViewController {
        let controllers = split.viewControllers
        detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
    self.users.getNextPage()
  }

  override func viewWillAppear(_ animated: Bool) {
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }

  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
        if let indexPath = tableView.indexPathForSelectedRow {
            let object = users.list[indexPath.row]
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.userItem = object
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
  }
  
  //MARK: - Users delegate
  
  func didUpdateUsers(withIndexPaths: [IndexPath]) {
    tableView.insertRows(at: withIndexPaths, with: .automatic)
    self.refreshControl?.endRefreshing()
  }
  
  func didResetUsers() {
    tableView.reloadData()
  }

  // MARK: - Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.list.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell

    let object = users.list[indexPath.row]
    cell.textLabel?.isHidden = true
    cell.fullName.text = object.fullName()
    cell.emailAddress.text = object.email
    cell.userImageView.kf.setImage(with: URL(string: object.picture.medium), placeholder: UIImage(named: "imgPlaceholder"))
    return cell
  }
  
  @objc
  func refreshTable() {
    users.refreshFeed()
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        users.list.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == self.users.list.count-1 { //you might decide to load sooner than -1 I guess...
      self.users.getNextPage()
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(80)
  }


}

