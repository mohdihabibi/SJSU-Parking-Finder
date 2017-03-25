//
//  InfoViewController.swift
//  ParkingMap
//


import UIKit
import MapKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var waypointToEdit: ParkingPin? { didSet { updateUI() } }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var garageImage: UIImageView!
    
    @IBOutlet weak var garageTitleLabel: UILabel!
    
    
    fileprivate func updateUI() {
        garageTitleLabel?.text = waypointToEdit?.locationName
        garageImage?.image = waypointToEdit?.image
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypointToEdit?.availableSpotsOnEachFloor.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SpotsTableViewCell
        cell.spotsNumber.text = "Floor # " + String(describing: indexPath.row+1) + " Available Spots: " + String(describing: (waypointToEdit?.availableSpotsOnEachFloor[indexPath.row])!)
        return cell
    }

}
