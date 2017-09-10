//
//  ModalStieInfoViewController.swift
//  OOG-iOS
//
//  Created by Nathan on 10/09/2017.
//  Copyright © 2017 Nathan. All rights reserved.
//

import UIKit

class ModalStieInfoViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = MAMapView(frame: CGRect(x: 0, y: 109, width: view.bounds.width, height: view.bounds.height))
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        mapView.showsScale = false
        self.view.addSubview(mapView!)
        
        //initSearch
        search = AMapSearchAPI()
        search.delegate = self
    }

    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
}
