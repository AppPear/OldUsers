//
//  DetailViewController.swift
//  OldUsers
//
//  Created by Samu András on 2019. 09. 17..
//  Copyright © 2019. Samu András. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit

class DetailViewController: UIViewController {
  @IBOutlet var profilePicture: UIImageView?
  @IBOutlet var personalInfoContainer: UIView!
  @IBOutlet var addressContainer: UIView!
  @IBOutlet var fullName: UILabel!
  @IBOutlet var nationality: UILabel!
  @IBOutlet var dateOfBirth: UILabel!
  @IBOutlet var email: UILabel!
  @IBOutlet var phone: UILabel!
  @IBOutlet var cell: UILabel!
  @IBOutlet var dateOfRegistration: UILabel!
  @IBOutlet var street: UILabel!
  @IBOutlet var city: UILabel!
  @IBOutlet var state: UILabel!
  @IBOutlet var mapView: MKMapView!
  @IBOutlet var contentView: UIView!
  func configureView() {
    // Update the user interface for the detail item.
    if let user = userItem, let imageView = profilePicture {
      self.personalInfoContainer.isHidden = false
      self.addressContainer.isHidden = false
      self.mapView.isHidden = false

      self.navigationItem.title = user.fullName()
      imageView.kf.setImage(with: URL(string: user.picture.large), placeholder: UIImage(named: "imgPlaceholder"))
      imageView.layer.cornerRadius = 64
      self.fullName.text = user.fullName()
      self.nationality.text = user.nat
      self.dateOfBirth.text = formatDate(dateString: user.dob.date)
      self.email.text = user.email
      self.phone.text = user.phone
      self.cell.text = user.cell
      self.dateOfRegistration.text = formatDate(dateString: user.registered.date)
      self.street.text = user.location.street
      self.city.text = user.location.city
      self.state.text = user.location.state
      
      let coordinate = CLLocationCoordinate2D(
        latitude:Double(user.location.coordinates.latitude)!,
        longitude: Double(user.location.coordinates.longitude)!
      )
      let mapPin = MKPointAnnotation()
      mapPin.coordinate = coordinate
      let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
      let region = MKCoordinateRegion(center: coordinate, span: span)
      mapView.setRegion(region, animated: true)
      mapView.addAnnotation(mapPin)
    } else if let imageView = profilePicture  {
      imageView.image = UIImage(named: "imgPlaceholder")
      self.navigationItem.title = "Please select a user from the list"
      self.personalInfoContainer.isHidden = true
      self.addressContainer.isHidden = true
      self.mapView.isHidden = true
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.personalInfoContainer.layer.cornerRadius = 16
    self.addressContainer.layer.cornerRadius = 16
    self.mapView.layer.cornerRadius = 16
    configureView()
  }

  var userItem: User? {
    didSet {
        // Update the view.
        configureView()
    }
  }
  
  func formatDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from: dateString)
    
    let newFormat = DateFormatter()
    newFormat.dateFormat = "dd/MM/yyyy"
    return newFormat.string(from: date!)
  }


}

