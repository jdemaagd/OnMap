//
//  StudentsViewController.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/28/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import UIKit

class StudentsViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var studentTableView: UITableView!
    
    
    // MARK: - Variables
    
    var loadingIndicator: UIActivityIndicatorView!
    var students = [StudentInformation]()
    
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        self.view.addSubview(loadingIndicator)
        loadingIndicator.bringSubviewToFront(self.view)
        loadingIndicator.center = self.view.center
        showActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getStudentsList()
    }
    
    
    // MARK: - TableView Delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.StudentTableViewCell, for: indexPath)
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }

    
    // MARK: - private methods
    
    func getStudentsList() {
        showActivityIndicator()
        Client.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
        }
    }
    
    func hideActivityIndicator() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    func showActivityIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        showActivityIndicator()
        Client.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator()
            }
        }
    }
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
}
