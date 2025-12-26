//
// TQQRScannerViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import AVFoundation
import Combine
import Foundation
import UIKit

final class TQQRScannerViewModel: NSObject, ObservableObject {
    enum State: Equatable {
        case idle
        case scanning
        case detected(code: String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var settingsAlertMessage: String?
    @Published private(set) var bannerMessage: String?

    let session = AVCaptureSession()

    private let metadataOutput = AVCaptureMetadataOutput()
    private let sessionQueue = DispatchQueue(label: "qr.scanner.session.queue")
    private var isConfigured = false

    var detectedCode: String? {
        if case let .detected(code) = state {
            return code
        }
        return nil
    }

    var isScanning: Bool {
        if case .scanning = state {
            return true
        }
        return false
    }

    var shouldShowSettingsAlert: Bool {
        settingsAlertMessage != nil
    }

    func acknowledgeSettingsAlert() {
        settingsAlertMessage = nil
    }

    func start() {
        Task {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                configureAndStartSession()
            case .notDetermined:
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                if granted {
                    configureAndStartSession()
                } else {
                    await MainActor.run {
                        self.state = .idle
                        self.settingsAlertMessage = L10n.Qr.Permission.denied
                    }
                }
            case .denied, .restricted:
                await MainActor.run {
                    self.state = .idle
                    self.settingsAlertMessage = L10n.Qr.Permission.settings
                }
            @unknown default:
                await MainActor.run {
                    self.state = .idle
                    self.bannerMessage = L10n.Qr.Camera.unavailable
                }
            }
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.session.isRunning {
                self.session.stopRunning()
            }
            Task { @MainActor in
                self.state = .idle
            }
        }
    }

    func resetForNextScan() {
        guard case .detected = state else { return }
        configureAndStartSession()
    }

    private func configureAndStartSession() {
        sessionQueue.async { [weak self] in
            guard let self else { return }

            if !self.isConfigured {
                do {
                    try self.configureSession()
                    self.isConfigured = true
                } catch {
                    Task { @MainActor in
                        self.bannerMessage = L10n.Qr.Camera.configureFailed
                        self.state = .idle
                    }
                    return
                }
            }

            guard !self.session.isRunning else { return }
            self.session.startRunning()
            Task { @MainActor in
                self.bannerMessage = nil
                self.settingsAlertMessage = nil
                self.state = .scanning
            }
        }
    }

    private func configureSession() throws {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw ScannerError.deviceUnavailable
        }

        let deviceInput = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(deviceInput) {
            session.addInput(deviceInput)
        } else {
            throw ScannerError.inputFailed
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            throw ScannerError.outputFailed
        }

        session.commitConfiguration()
    }

    @MainActor
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension TQQRScannerViewModel: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let first = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              first.type == .qr,
              let value = first.stringValue else {
            return
        }

        if session.isRunning {
            session.stopRunning()
        }

        Task { [weak self] in
            await MainActor.run { [weak self] in
                guard let self else { return }

                if case .detected = self.state {
                    return
                }
                self.bannerMessage = nil
                self.state = .detected(code: value)
            }
        }
    }
}

extension TQQRScannerViewModel {
    enum ScannerError: Error {
        case deviceUnavailable
        case inputFailed
        case outputFailed
    }
}
