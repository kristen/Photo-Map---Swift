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

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    var currentImage: UIImage?
    
    var photoAnnotations = [PhotoMapAnnotation]()
    
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
        currentImage = editedImage
        
        // launch LocationsViewController to tag with a location
        performSegueWithIdentifier("AddLocationSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddLocationSegue" {
            println("AddLocationSegue segue worked")
            let locationsViewController = segue.destinationViewController as LocationsViewController
            locationsViewController.delegate = self
        }
    }
}

extension PhotoMapViewController: UINavigationControllerDelegate {
    
}

extension PhotoMapViewController: LocationsViewControllerDelegate {
    func locationsViewController(locationsViewController: LocationsViewController, didSelectLocation location: PhotoMapAnnotation) {
        // popViewController locationsViewController
        navigationController?.popViewControllerAnimated(true)
        
        println("lat: \(location.latitude) and lng: \(location.longitude)")
        photoAnnotations.append(location)
        mapView.addAnnotations(photoAnnotations)
        mapView.showAnnotations(photoAnnotations, animated: true)
    }
}

extension PhotoMapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseID = "PhotoMapAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView.canShowCallout = true
            let imageView = UIImageView(frame: CGRectMake(0, 0, 46, 46))
            if let currentImage = currentImage {
                println("image size: \(currentImage.size)")
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                println("image size aspect fit: \(currentImage.size)")
                imageView.image = currentImage
                println("currentImage set in annotationView")
                self.currentImage = nil
            }
            
            annotationView.leftCalloutAccessoryView = imageView
        }
        
        annotationView.annotation = annotation
        
        return annotationView
    }
    
}