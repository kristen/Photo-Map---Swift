//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Kristen on 3/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapCameraButton() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
}

extension PhotoMapViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        println("dismiss picker view controller")
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as UIImage
        
        // launch LocationsViewController to tag with a location
        performSegueWithIdentifier("AddLocationSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddLocationSegue" {
            println("AddLocationSegue segue worked")
            let locationsViewController = segue.destinationViewController as LocationsViewController
        }
        
    }
}

extension PhotoMapViewController: UINavigationControllerDelegate {
    
}