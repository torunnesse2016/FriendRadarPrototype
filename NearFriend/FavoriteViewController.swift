//
//  FavoriteViewController.swift
//  NearFriend
//
//  Created by MobileDev on 11/1/16.
//  Copyright © 2016 MobileDev. All rights reserved.
//

import UIKit
import SimpleAlert

class FavoriteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var favTableView: UITableView!
    var friends:NSMutableArray = []
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        initDatasource()
        self.title = "Favorite List"
    }

    func initDatasource() -> Void {
        friends = []
        if let favoritelist :NSArray = UserDefaults.standard.array(forKey: "favoritelist") as NSArray? {
            friends.removeAllObjects()
            for i in 0..<favoritelist.count {
                let frienditem = favoritelist[i]
                friends.add(frienditem)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FriendListCell = self.favTableView.dequeueReusableCell(withIdentifier: "FriendListCell") as! FriendListCell
        
        let friend:NSDictionary = self.friends[indexPath.row] as! NSDictionary
        cell.username?.text = friend.object(forKey: "name") as! String?
        cell.btnadd.tag = indexPath.row
        cell.btnadd.addTarget(self, action: #selector(deleteFavorite), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count;
    }
    func deleteFavorite(sender: UIButton){
        let buttonTag = sender.tag
        
        let selectedFriend = friends[buttonTag];
        
        let userDefaults = UserDefaults.standard
                
        
        if let favoritetemplist :NSArray = UserDefaults.standard.array(forKey: "favoritelist") as NSArray? {
            
            let favoritelist:NSMutableArray = (userDefaults.array(forKey: "favoritelist") as! NSArray).mutableCopy() as! NSMutableArray
            
                        
            favoritelist.remove(selectedFriend)
            userDefaults.set(favoritelist, forKey: "favoritelist")
            
            userDefaults.synchronize()
            
            let alert = AlertController(title: "Information!", message: "Deleted from Favorite list", style: .alert)
            alert.addAction(AlertAction(title: "OK", style: .cancel))
            present(alert, animated: true, completion: nil)
            
            self.initDatasource()
            self.favTableView.reloadData()

            
        }
        
        
               //update table view
        
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
