//
//  ChooseLocationViewController.swift
//  NearFriend
//
//  Created by MobileDev on 11/1/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit
import GoogleMaps

class ChooseLocationViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var selectedLocation:CLLocationCoordinate2D!
    
    var marker:GMSMarker!
    
    @IBOutlet weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self;
        marker = GMSMarker()
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 6.0)
        mapView.camera = camera;
        updateCurLocation(location: currentLocation.coordinate)
    
        print("Current Locations = \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
        
        self.title = "Choose Location"
        self.navigationItem.backBarButtonItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneTapped))
        
    }
    func DoneTapped(sender:Any)
    {
        self.performSegue(withIdentifier: "chooseLocationToMain", sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        updateCurLocation(location: coordinate)
    }

    func updateCurLocation(location:CLLocationCoordinate2D) -> Void{
        
        mapView.animate(toLocation: location)
        
        if (marker.map == nil) {
            
        }else{
            marker.map = nil;
        }
        
        mapView.isMyLocationEnabled = true
        
        // Creates a marker in the center of the map.
        marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        marker.title = "Your Location"
        marker.snippet = ""
        marker.map = mapView
        
        selectedLocation = location
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setCurLocation(_ sender: AnyObject) {
        updateCurLocation(location: currentLocation.coordinate)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chooseLocationToMain" {
            let viewController:MainViewController = segue.destination as! MainViewController
            viewController.selectedLocation = self.selectedLocation
        }
    }
    

}
