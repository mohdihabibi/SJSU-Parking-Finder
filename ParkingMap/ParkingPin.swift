

import Foundation
import MapKit
import Contacts

class ParkingPin: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
    var availableSpotsOnEachFloor = [Int]()
  let coordinate: CLLocationCoordinate2D
    let image: UIImage
  
    init(title: String, locationName: String, availableSpotsOnEachFloor: [Int], coordinate: CLLocationCoordinate2D, image: UIImage) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate
    self.availableSpotsOnEachFloor = availableSpotsOnEachFloor
    self.image = image
        
    super.init()
  }
  
  

  
}
