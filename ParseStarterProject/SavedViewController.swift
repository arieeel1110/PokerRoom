//
//  SavedViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Shumin Gao on 8/31/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SavedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    var usernames = [""]
    var userids = [""]
    
    var favorPost = [PFObject]()
    
    var valueToPass:String!
    var picToPass:UIImage!
    var authorToPass:String!
    var titleToPass:String!
    
    var profileCell:ProfileTableViewCell!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func logout(sender: AnyObject) {
        //--------------------------------------
        // Option 1: Show a message asking the user to log out and log back in.
        //--------------------------------------
        // If the user needs to finish what they were doing, they have the opportunity to do so.
        
        let alertView = UIAlertView(
            title: "Warning!",
            message: "Are you sure you want to log out?",
            delegate: nil,
            cancelButtonTitle: "cancel",
            otherButtonTitles: "Log Out"
        )
        alertView.show()
        
        
        //--------------------------------------
        // Option #2: Show login screen so user can re-authenticate.
        //--------------------------------------
        // You may want this if the logout button is inaccessible in the UI.
//        //
//        let presentingViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
//        let logInViewController = PFLogInViewController()
//        presentingViewController?.presentViewController(logInViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //*** delete lines
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                
        var user = PFUser.currentUser()
        var relation = user!.relationForKey("likes")
        
        relation.query()?.findObjectsInBackgroundWithBlock({(objects:[AnyObject]?, error:NSError?) -> Void in
            if let error = error {
                // There was an error
            } else {
                // objects has all the Posts the current user liked.
                self.favorPost = objects as! [PFObject]
                self.tableView.reloadData()
            }
        })
        // Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
            return favorPost.count+2
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.row==0){
            return 230
        }
        else if (indexPath.row==1){
            return 36
        }
        else{
            return 70
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if  (indexPath.row == 0) {

           profileCell =           tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileTableViewCell

            return profileCell
            
        }
        else if (indexPath.row == 1) {
            
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "favouriteCell")
            
            
            cell.textLabel?.text = "MY FAVOURITES"
            cell.imageView?.image = UIImage(named:"favourite")
            
            let size = CGSizeMake(28, 28)
            
            cell.imageView?.image! = imageResize(image:cell.imageView!.image!,sizeChange: size)

            
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(13))
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
            
            return cell
        }
            
            
        else {
        
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "favouriteCell")
            
            
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(13))
            cell.textLabel?.text = (favorPost[indexPath.row-2]).valueForKey("title") as? String
            
            //author
            let author = (favorPost[indexPath.row-2]).valueForKey("uploader") as! PFUser
            author.fetchIfNeeded()
            
            //authorName
            var authorName = author.username as String!
            
            cell.detailTextLabel?.font = UIFont(name: "Avenir", size: CGFloat(12))
            cell.detailTextLabel?.text = "@\(authorName)"
            cell.detailTextLabel?.textColor = UIColor.grayColor()
            
            var userImageFile = (favorPost[indexPath.row-2]).valueForKey("imageFile") as? PFFile
            var image = UIImage(data: userImageFile!.getData()!)
            
            cell.imageView?.image = maskRoundedImage(image!)
            
            return cell
        }
    }
    
    func maskRoundedImage(image: UIImage) -> UIImage {
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        imageView.image = image
        
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(20)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext())
        var roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    func imageResize (#image:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            var query = PFQuery(className:"Post")
            var currentObject = self.favorPost[indexPath!.row - 2] as PFObject
            
            var user = PFUser.currentUser()
            var relation = user!.relationForKey("likes")
            relation.removeObject(currentObject)
            
            user!.saveInBackground()
            
            self.favorPost.removeAtIndex(indexPath!.row-2)
            self.tableView.reloadData()
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //CODE TO BE RUN ON CELL TOUCH
        
        if indexPath.row > 1 {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        var currentPerson = self.favorPost[row-2] as PFObject
        
        self.valueToPass = currentPerson.valueForKey("imageText") as! String
        
        var author =  currentPerson.valueForKey("uploader") as! PFUser
        
        self.authorToPass = author.username
        self.titleToPass = currentPerson.valueForKey("title") as! String
        
        var picFile = author.objectForKey("profilePicture") as? PFFile
        
        self.picToPass = UIImage(data: picFile!.getData()!)
        
        self.performSegueWithIdentifier("SaveToText", sender: self)
        }
            
        else if indexPath == 0 {
            println("well")
            self.performSegueWithIdentifier("SaveToUpload", sender: self)
        }

    }
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "SaveToText") {
                        
            // initialize new view controller and cast it as your view controller
            var viewController = segue.destinationViewController as! TextViewController
            // your new view controller should have property that will store passed value
            viewController.passedText = valueToPass
            viewController.passedPic = picToPass
            viewController.passedAuthor = authorToPass
            viewController.passedTitle = titleToPass
        }
     
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
