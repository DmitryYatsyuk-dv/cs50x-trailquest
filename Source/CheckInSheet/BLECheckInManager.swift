//
// BLECheckInManager.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreBluetooth
import CoreLocation
import Foundation
import Combine
import UIKit

final class BLECheckInManager: NSObject, ObservableObject {
    @Published var nearbyBeaconID: UUID?
    @Published var authorizationDenied = false

    private let locationManager = CLLocationManager()
    private var beaconUUIDString: String?
    private var beaconRegion: CLBeaconRegion?
    private var identityConstraint: CLBeaconIdentityConstraint?
    private var isSimulated = false
    private var centralManager: CBCentralManager?
    private var awaitingBluetoothAuthorization = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    // MARK: - Public API

    func startSearch(for beaconID: String) {
        authorizationDenied = false
        nearbyBeaconID = nil
        beaconUUIDString = beaconID

        guard UUID(uuidString: beaconID) != nil else {
            authorizationDenied = true
            return
        }

        guard ensureBluetoothIsReady() else { return }
        proceedWithLocationAuthorization()
    }

    func stop() {
        if let region = beaconRegion {
            locationManager.stopMonitoring(for: region)
        }
        if let constraint = identityConstraint {
            locationManager.stopRangingBeacons(satisfying: constraint)
        }
        nearbyBeaconID = nil
        beaconUUIDString = nil
        isSimulated = false
        awaitingBluetoothAuthorization = false
    }

    // MARK: - Internal BLE logic

    private func ensureBluetoothIsReady() -> Bool {
        if centralManager == nil {
            centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        }

        guard let manager = centralManager else { return false }

        if #available(iOS 13.1, *) {
            switch CBManager.authorization {
            case .denied, .restricted:
                authorizationDenied = true
                return false
            default:
                break
            }
        }

        switch manager.state {
        case .poweredOn:
            awaitingBluetoothAuthorization = false
            return true
        case .unknown, .resetting:
            awaitingBluetoothAuthorization = true
            return false
        case .unsupported, .unauthorized, .poweredOff:
            authorizationDenied = true
            return false
        @unknown default:
            authorizationDenied = true
            return false
        }
    }

    private func proceedWithLocationAuthorization() {
        guard CLLocationManager.locationServicesEnabled() else {
            authorizationDenied = true
            return
        }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            beginMonitoring()

        case .denied, .restricted:
            authorizationDenied = true

        @unknown default:
            authorizationDenied = true
        }
    }

    private func beginMonitoring() {
        guard
            let beaconUUIDString,
            let uuid = UUID(uuidString: beaconUUIDString)
        else {
            authorizationDenied = true
            return
        }

        let region = CLBeaconRegion(uuid: uuid, identifier: "TrailQuestBeacon")
        region.notifyEntryStateOnDisplay = true
        beaconRegion = region

        let constraint = CLBeaconIdentityConstraint(uuid: uuid)
        identityConstraint = constraint

        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(satisfying: constraint)
    }
}

// MARK: - CLLocationManagerDelegate
extension BLECheckInManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            beginMonitoring()
        case .denied, .restricted:
            authorizationDenied = true
            stop()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ BLE Error:", error.localizedDescription)
        authorizationDenied = true
        stop()
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        guard let nearest = beacons.sorted(by: { $0.accuracy < $1.accuracy }).first else {
            if nearbyBeaconID != nil {
                nearbyBeaconID = nil
            }
            return
        }

        // если точность плохая — игнорируем
        if nearest.accuracy < 0 || nearest.accuracy > 5 {
            if nearbyBeaconID != nil {
                nearbyBeaconID = nil
            }
            return
        }

        if nearbyBeaconID != nearest.uuid {
            DispatchQueue.main.async {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.nearbyBeaconID = nearest.uuid
                print("📡 BLE Beacon detected:", nearest.uuid, "accuracy:", nearest.accuracy)
            }
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BLECheckInManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if awaitingBluetoothAuthorization {
                awaitingBluetoothAuthorization = false
                DispatchQueue.main.async { [weak self] in
                    self?.proceedWithLocationAuthorization()
                }
            }
        case .unauthorized, .poweredOff, .unsupported:
            authorizationDenied = true
            stop()
        case .resetting, .unknown:
            awaitingBluetoothAuthorization = true
        @unknown default:
            authorizationDenied = true
            stop()
        }
    }
}
