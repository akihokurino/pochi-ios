//
//  MapCell.swift
//  pochi
//
//  Created by akiho on 2017/01/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import MapKit

class MapCell: UITableViewCell {
    
    static let HEIGHT = 185
    static let IDENTITY: String = R.reuseIdentifier.mapCell.identifier
    static let NIB: UINib = R.nib.mapCell()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(address: Address) {
        let coordinate = CLLocationCoordinate2DMake(address.latitude, address.latitude)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated:true)
        
        addressLabel.text = address.address
    }
    
    func hideAddress() {
        self.addressLabel.isHidden = true
    }
}
