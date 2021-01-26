//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Alexandre Bianchi on 17/01/21.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentURL: UILabel!
}

class TableViewController: UITableViewController {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // Add it to the studentLocations array in the Application Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of prompts in the storyNode (The 2 is just a place holder)
        return appDelegate.studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue a cell and populate it with text from the correct prompt.
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell") as! StudentLocationTableViewCell
        cell.studentName?.text = appDelegate.studentLocations[(indexPath as NSIndexPath).row].firstName + " " + appDelegate.studentLocations[(indexPath as NSIndexPath).row].lastName
        cell.studentURL?.text = appDelegate.studentLocations[(indexPath as NSIndexPath).row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! StudentLocationTableViewCell
        let app = UIApplication.shared
        if let toOpen = currentCell.studentURL?.text! {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        UdacityClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            showFailure(title: "Logout Failed", message: "It was not possible to do logout!")
        }
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        refreshButton.isEnabled = false
        UdacityClient.getStudentLocations(completion: handleStudentLocationsResponse(locations:error:))
    }
    
    func handleStudentLocationsResponse(locations: [StudentLocation], error: Error?) {
        refreshButton.isEnabled = true
        
        if error == nil {
            appDelegate.studentLocations = locations
            self.tableView.reloadData()
        } else {
            showFailure(title: "Get Student Locations Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    func showFailure(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
