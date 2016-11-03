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
import KRProgressHUD

class MainViewController: UIViewController,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate{
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    var selectedLocation:CLLocationCoordinate2D!
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
        currentLocation = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
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
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 6.0)
        mapView.camera = camera;
        updateCurLocation(location: currentLocation.coordinate)
    }
    
    func updatelocation_start(){
        print("Periodical update location to server "+String(currentLocation.coordinate.longitude)+"-"+String(currentLocation.coordinate.latitude))
        webservice_updatelocation(newLocation: currentLocation.coordinate)
    }
    func webservice_updatelocation(newLocation:CLLocationCoordinate2D){
        // update web service calling
        //update user's current location
        let email = UserDefaults.standard.object(forKey: "UserEmail") as! String
        let id = UserDefaults.standard.object(forKey: "UserID") as! String
        
        
        //        http://127.0.0.1:81/update_location?email=email_fb3@test.ru&user_id=2&longitude=15.087269&latitude=37.502669
        let url_temp = AppConstants.BASE_URL+"/update_location?email="+email+"&user_id="+id+"&longitude="+String(currentLocation.coordinate.longitude)+"&latitude="+String(currentLocation.coordinate.latitude)
        let url = url_temp.addingPercentEscapes(using: String.Encoding.utf8)
        
        Alamofire.request(url!).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let responseDictionary = JSON as! NSDictionary
                let success = responseDictionary.object(forKey: "sucess")! as! Bool
                if (success){
                    print("updated location success : "+String(self.currentLocation.coordinate.longitude)+"-"+String(self.currentLocation.coordinate.latitude))
                }else{
                    print("updated location failed : "+String(self.currentLocation.coordinate.longitude)+"-"+String(self.currentLocation.coordinate.latitude))

//                    let alert = AlertController(title: "Information!", message: "loading Failed", style: .alert)
//                    alert.addAction(AlertAction(title: "OK", style: .cancel))
//                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        

    }
    @IBAction func onClickedRefresh(_ sender: AnyObject) {
        initDatasource()

        
        
    }
    func updateDataSource(){
        
        //update user's current location
        KRProgressHUD.show(message:"loading...")
        let email = UserDefaults.standard.object(forKey: "UserEmail") as! String
        let id = UserDefaults.standard.object(forKey: "UserID") as! String

        
//        http://127.0.0.1:81/update_location?email=email_fb3@test.ru&user_id=2&longitude=15.087269&latitude=37.502669
        let url_temp = AppConstants.BASE_URL+"/update_location?email="+email+"&user_id="+id+"&longitude="+String(currentLocation.coordinate.longitude)+"&latitude="+String(currentLocation.coordinate.latitude)
        let url = url_temp.addingPercentEscapes(using: String.Encoding.utf8)
        
        Alamofire.request(url!).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // HTTP URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let responseDictionary = JSON as! NSDictionary
                let success = responseDictionary.object(forKey: "sucess")! as! Bool
                if (success){
                    // fetch list of informations
                    KRProgressHUD.show(message:"loading...")
                    let email = UserDefaults.standard.object(forKey: "UserEmail") as! String
                    let id = UserDefaults.standard.object(forKey: "UserID") as! String
                    
                    
                    //http://127.0.0.1:81/find_nearest?email=email_fb3@test.ru&user_id=2&longitude=15.087269&latitude=37.502669&distance=100&dist_unit=km
                    let url_temp = AppConstants.BASE_URL+"/find_nearest?email="+email+"&user_id="+id+"&longitude="+String(self.currentLocation.coordinate.longitude)+"&latitude="+String(self.currentLocation.coordinate.latitude)+"&distance=1&dist_unit=mi"
                    let url = url_temp.addingPercentEscapes(using: String.Encoding.utf8)
                    
                    Alamofire.request(url!).responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // HTTP URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        
                        switch response.result {
                        case .success(let JSON):
                            print("Success with JSON: \(JSON)")
                            KRProgressHUD.dismiss()
                            let responseDictionary = JSON as! NSDictionary
                            let success = responseDictionary.object(forKey: "sucess")! as! Bool
                            if (success){
                                // fetch list of informations
                                let dataArray:NSMutableArray = NSMutableArray.init(array: (responseDictionary.object(forKey: "data")! as! NSArray))
                                
                                KRProgressHUD.dismiss()
                                if(dataArray.count == 0){
                                    let alert = AlertController(title: "Information!", message: "There is no friend in 1 mile", style: .alert)
                                    alert.addAction(AlertAction(title: "OK", style: .cancel))
                                    self.present(alert, animated: true, completion: nil)
                                }else{
                                    for i in 0..<dataArray.count {
                                        let friendItem_temp = dataArray[i] as! NSDictionary
                                        let name_temp = friendItem_temp.object(forKey: "username") as! String
                                        let user_id_temp = friendItem_temp.object(forKey: "user_id") as! String
                                        let latitude_temp = friendItem_temp.object(forKey: "latitude") as! String
                                        let longitude_temp = friendItem_temp.object(forKey: "longitude") as! String
                                        let distance_temp = friendItem_temp.object(forKey: "distance") as! String
                                        
                                        
                                        if(user_id_temp == id){
                                            
                                        }else{
                                            let friendItem = Friend.init(name: name_temp, latitude: Double(latitude_temp)!, longitude: Double(longitude_temp)!,imageUrl:"")
                                            self.friends.append(friendItem)
                                        }
                                        
                                        
                                    }
                                    self.updateMarkers(friendslist: self.friends)
                                }
                                
                                
                                
                            }else{
                                KRProgressHUD.dismiss()
                                let alert = AlertController(title: "Information!", message: "loading Failed", style: .alert)
                                alert.addAction(AlertAction(title: "OK", style: .cancel))
                                self.present(alert, animated: true, completion: nil)
                            }
                        case .failure(let error):
                            KRProgressHUD.dismiss()
                            let alert = AlertController(title: "Information!", message: "loading Failed", style: .alert)
                            alert.addAction(AlertAction(title: "OK", style: .cancel))
                            self.present(alert, animated: true, completion: nil)
                            print("Request failed with error: \(error)")
                        }
                    }
                }else{
                    KRProgressHUD.dismiss()
                    let alert = AlertController(title: "Information!", message: "loading Failed", style: .alert)
                    alert.addAction(AlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                KRProgressHUD.dismiss()
                print("Request failed with error: \(error)")
            }
        }
        
       
    }
    func initDatasource(){
        friends = []
        updateDataSource()
        updatelocation_start()
        //update location every 1 minute
        var timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.updatelocation_start), userInfo: nil, repeats: true);
    
//        let fr1 = Friend.init(name: "Jumping Jacks1", latitude: 38.91, longitude: -76.95879+2.0,imageUrl:"sdfs")
//        let fr2 = Friend.init(name: "Jumping Jacks2", latitude: 38.91, longitude: -76.85879+2.0,imageUrl:"sdfs")
//        let fr3 = Friend.init(name: "Jumping Jacks3", latitude: 38.91, longitude: -76.75879+2.0,imageUrl:"sdfs")
//        let fr4 = Friend.init(name: "Jumping Jacks4", latitude: 38.91, longitude: -76.65879+2.0,imageUrl:"sdfs")
//        let fr5 = Friend.init(name: "Jumping Jacks5", latitude: 38.91, longitude: -76.55879+2.0,imageUrl:"sdfs")
//        friends.append(fr1)
//        friends.append(fr2)
//        friends.append(fr3)
//        friends.append(fr4)
//        friends.append(fr5)
//        updateMarkers(friendslist: friends)
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
        
        self.friendTableView.reloadData()
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
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let meterdist:CLLocationDistance = (manager.location?.distance(from: currentLocation))!
        //if location distance difference is over 100Meter
        if (meterdist >= 100) {
            //distance different is over 100
            //call web service for update location
            print("Distance update location to server "+String(manager.location!.coordinate.longitude)+"-"+String(manager.location!.coordinate.latitude))
            webservice_updatelocation(newLocation: manager.location!.coordinate)
        }
        currentLocation = manager.location
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
