//
//  MainViewController.swift
//  NearFriend
//
//  Created by MobileDev on 10/31/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import SimpleAlert
import Alamofire


class MainViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate{
    let locationManager = CLLocationManager()
    var currentLocation:CLLocationCoordinate2D!
    var marker:GMSMarker!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var switchView: UISegmentedControl!
    var friends:[Friend] = []
    var items: [String] = ["We", "Heart", "Swift"]
    
    @IBOutlet weak var friendTableView: UITableView!
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.switchView.selectedSegmentIndex = 0;
        self.mapView.isHidden = true
        self.friendTableView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        initDatasource()
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        mapView.delegate = self;
        marker = GMSMarker()
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.latitude, longitude: currentLocation.longitude, zoom: 6.0)
        mapView.camera = camera;
        updateCurLocation(location: currentLocation)
    }
    
    func initDatasource(){
        friends = []
        
        
//        //fetch nearest friends
//        
//        let baseURL:String!
//        baseURL = "baseurl"
//        
//        let useremail:String = UserDefaults.standard.value(forKey: "UserEmail") as! String
//
//        
//        let url:String = baseURL+"fetchnearfriend?useremail="+useremail
//        Alamofire.request(url).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
        
        //update location
        
//        let baseURL:String!
//        baseURL = "baseurl"
//        
//        let useremail:String = UserDefaults.standard.value(forKey: "UserEmail") as! String
//        
//        
//        let url:String = baseURL+"updatelocation?useremail="+useremail+"&latitude="+currentLocation.latitude+"&longitude"+currentLocation.longitude
//        Alamofire.request(url).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
        
        
        
        let fr1 = Friend.init(name: "Jumping Jacks1", latitude: 38.91, longitude: -76.95879+2.0,imageUrl:"sdfs")
        let fr2 = Friend.init(name: "Jumping Jacks2", latitude: 38.91, longitude: -76.85879+2.0,imageUrl:"sdfs")
        let fr3 = Friend.init(name: "Jumping Jacks3", latitude: 38.91, longitude: -76.75879+2.0,imageUrl:"sdfs")
        let fr4 = Friend.init(name: "Jumping Jacks4", latitude: 38.91, longitude: -76.65879+2.0,imageUrl:"sdfs")
        let fr5 = Friend.init(name: "Jumping Jacks5", latitude: 38.91, longitude: -76.55879+2.0,imageUrl:"sdfs")
        friends.append(fr1)
        friends.append(fr2)
        friends.append(fr3)
        friends.append(fr4)
        friends.append(fr5)
        updateMarkers(friendslist: friends)

    }
    func updateMarkers(friendslist:[Friend]){
        
        
        for i in 0..<friendslist.count {
            
            let frienditem = friendslist[i]
            
            var markerItem:GMSMarker!
            markerItem = GMSMarker()
            markerItem.position = CLLocationCoordinate2D(latitude: frienditem.latitude, longitude: frienditem.longitude)
            markerItem.title = frienditem.name
            markerItem.snippet = ""
            markerItem.map = mapView
        }
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
    }
    @IBAction func onClickedFav(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "mainToFavorite", sender: self)
        
    }
    @IBAction func onClickedLogout(_ sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onChangeSwitchValue(_ sender: AnyObject) {
        
        let switchSeg:UISegmentedControl = sender as! UISegmentedControl
        switch switchSeg.selectedSegmentIndex {
        case 0:
            self.mapView.isHidden = true
            self.friendTableView.isHidden = false
            break;
        case 1:
            self.mapView.isHidden = false
            self.friendTableView.isHidden = true
            break;
        default:
            self.mapView.isHidden = true
            self.friendTableView.isHidden = false
            break;
        }
        
    }
    //Getting Current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FriendListCell = self.friendTableView.dequeueReusableCell(withIdentifier: "FriendListCell") as! FriendListCell
        
        let friend = self.friends[indexPath.row]
        cell.username?.text = friend.name
        cell.btnadd.tag = indexPath.row
        cell.btnadd.addTarget(self, action: #selector(addFavorite), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count;
    }
    func addFavorite(sender: UIButton){
        let buttonTag = sender.tag
        
        let selectedFriend = friends[buttonTag];
        
        let userDefaults = UserDefaults.standard
        
        
        
        if let favoritetemplist :NSArray = UserDefaults.standard.array(forKey: "favoritelist") as NSArray? {
            
            let favoritelist:NSMutableArray = (userDefaults.array(forKey: "favoritelist") as! NSArray).mutableCopy() as! NSMutableArray
            
            let tempItem:NSMutableDictionary! = NSMutableDictionary.init()
            tempItem.setValue(selectedFriend.imageUrl, forKey: "imageUrl")
            tempItem.setValue(selectedFriend.longitude, forKey: "longitude")
            tempItem.setValue(selectedFriend.latitude, forKey: "latitude")
            tempItem.setValue(selectedFriend.name, forKey: "name")
            
            //check duplicated 
            if favoritelist.contains(tempItem) {
                
                let alert = AlertController(title: "Information!", message: "Already in Favorite List", style: .alert)
                alert.addAction(AlertAction(title: "OK", style: .cancel))
                present(alert, animated: true, completion: nil)
            }else{
                favoritelist.add(tempItem)
                userDefaults.set(favoritelist, forKey: "favoritelist")
                userDefaults.synchronize()
                
                let alert = AlertController(title: "Information!", message: "Added to Favorite list", style: .alert)
                alert.addAction(AlertAction(title: "OK", style: .cancel))
                present(alert, animated: true, completion: nil)
            }
        }else{
            let favoritelist:NSMutableArray! = NSMutableArray.init()
            
            
            let tempItem:NSMutableDictionary! = NSMutableDictionary.init()
            tempItem.setValue(selectedFriend.imageUrl, forKey: "imageUrl")
            tempItem.setValue(selectedFriend.longitude, forKey: "longitude")
            tempItem.setValue(selectedFriend.latitude, forKey: "latitude")
            tempItem.setValue(selectedFriend.name, forKey: "name")

            
            favoritelist.add(tempItem)
            
            userDefaults.set(favoritelist, forKey: "favoritelist")
            userDefaults.synchronize()
            
            let alert = AlertController(title: "Information!", message: "Added to Favorite list", style: .alert)
            alert.addAction(AlertAction(title: "OK", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
