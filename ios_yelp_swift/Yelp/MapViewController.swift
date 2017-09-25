//
//  MapViewController.swift
//  Yelp
//
//  Created by YingYing Zhang on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventAnnotation: MKPointAnnotation {
    var myEvent: Business?
}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    
    var theEvent: EventAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        // Set up center location
        let centerLocation = CLLocation(latitude: businesses[0].latitude!, longitude: businesses[0].longitude!)
        goToLocation(location: centerLocation)
        
        for business in businesses {
            
            let annotation = EventAnnotation()
            
            annotation.myEvent = business
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            mapView.addAnnotation(annotation)
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.pinTintColor = UIColor(red:0.74, green:0.11, blue:0.00, alpha:1.0)
        annotationView!.animatesDrop = true
        
        annotationView!.canShowCallout = false
          //  setImageWith(business.imageURL!)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let annotation = view.annotation as? EventAnnotation {
            theEvent = annotation
            print("mapView event")
            performSegue(withIdentifier: "mapToDetailsViewController", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToDetailsViewController" {
            let navigationController = segue.destination as! UINavigationController
            let detailsViewController = navigationController.topViewController as! DetailsViewController
            detailsViewController.business = theEvent.myEvent
            
            
        }
    }
    
}
