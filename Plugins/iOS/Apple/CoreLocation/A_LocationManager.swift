import Foundation
import CoreLocation
import os.log

public final class A_LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    public private(set) var latestLocation: CLLocation?

    public override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
    }

    public func requestPermission() {
        os_log("[A_LocationManager] Requesting location permission", type: .default)
        manager.requestWhenInUseAuthorization()
    }

    public func startLocationUpdates() {
        os_log("[A_LocationManager] Starting location updates", type: .default)
        manager.startUpdatingLocation()
    }

    public func stopLocationUpdates() {
        os_log("[A_LocationManager] Stopping location updates", type: .default)
        manager.stopUpdatingLocation()
    }

    public func getLatestLocation() -> CLLocation? {
        return latestLocation
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            return
        }

        latestLocation = location

        os_log(
            "[A_LocationManager] lat=%f lon=%f alt=%f accuracy=%f",
            type: .default,
            location.coordinate.latitude,
            location.coordinate.longitude,
            location.altitude,
            location.horizontalAccuracy
        )
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        os_log("[A_LocationManager] Error: %@", type: .error, error.localizedDescription)
    }
}
