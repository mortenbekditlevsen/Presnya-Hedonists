//
//  MapVC.swift
//  PresnyaHedonist
//
//  Created by Alexandr L. on 7/13/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    var place: Place?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureMap()
    }
    
    
    func configureMap() {
        if place != nil {
            let location = CLLocationCoordinate2D(latitude: place!.lat, longitude: place!.long)
            let pin = MKPointAnnotation()
            let region = MKCoordinateRegion(center: location, latitudinalMeters: UISettings.regionZoom, longitudinalMeters: UISettings.regionZoom)
            
            pin.coordinate = location
            
            mapView.addAnnotation(pin)
            mapView.setRegion(region, animated: false)
        }
    }
}
