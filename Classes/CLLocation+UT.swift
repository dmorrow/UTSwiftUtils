//
//  CLLocation+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    public func distanceInMiles(_ location:CLLocation)->Double {
        return self.distance(from: location)/1609.344
    }
    
    public func formattedDistanceInMiles(_ location:CLLocation, format:String = "%.1f mi")->NSString{
        return NSString(format: format as NSString, self.distanceInMiles(location))
    }
}
