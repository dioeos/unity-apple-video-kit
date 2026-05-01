import Foundation
import CoreLocation
import os.log

public final class CoreLocationService: NSObject {
    private let locationManager: A_LocationManager

    public init(locationManager: A_LocationManager = A_LocationManager()) {
        self.locationManager = locationManager
        super.init()
    }

    public func requestPermission() {
        locationManager.requestPermission()
    }

    public func start() {
        locationManager.startLocationUpdates()
    }

    public func stop() {
        locationManager.stopLocationUpdates()
    }

    public func getLatestLocation() -> CLLocation? {
        return locationManager.getLatestLocation()
    }
}
