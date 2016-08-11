//
//  NameGroupViewController.swift
//  Fuber
//
//  Created by Matt Eng on 8/1/16.
//  Copyright © 2016 EngTech. All rights reserved.
//

import UIKit
import Parse

class NameGroupViewController: UIViewController {

    @IBAction func unwindToGroup(segue: UIStoryboardSegue) {}
    @IBOutlet weak var nameTF: UITextField!
    @IBAction func AddUserButtonTouched(sender: AnyObject) {
        createGroup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        nameTF.keyboardAppearance = .Dark
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGroup () {
        if nameTF.text != "" {
//            ParseHelper.createGroup(nameTF.text!, creator: PFUser.currentUser()!)
            performSegueWithIdentifier("AddUsersSegue", sender: self)
        } else {
            let alert = UIAlertView()
            alert.title = "Error"
            alert.message = "There is no name for the group"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Make sure your segue name in storyboard is the same as this line
        if (segue.identifier == "AddUsersSegue") {
            if let destination = segue.destinationViewController as? TempGroupCreatorViewController {
//                let path = tableView.indexPathForSelectedRow
//                let cell = tableView.cellForRowAtIndexPath(path!)
                destination.titleLabelText = nameTF.text
            }
        }
        nameTF.text = ""
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Style
extension NameGroupViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
