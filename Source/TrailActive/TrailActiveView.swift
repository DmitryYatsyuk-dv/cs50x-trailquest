//
// TrailActiveView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation
import MapKit
import SwiftUI
import Combine

struct TrailActiveView: View {
    @Environment(\.palette) private var palette
    @Environment(\.competitionStore) private var competitionStore
    @Environment(\.scenePhase) private var scenePhase

    let trailName: String
    let parkID: Int
    let points: [TrailPoint]
    let onPresented: (() -> Void)?
    let onSummaryDismiss: (() -> Void)?

    @State private var region: MKCoordinateRegion
    @State private var startDate: Date = Date()
    @State private var elapsedTime: TimeInterval = 0
    @State private var isPaused = false
    @State private var pauseStartedAt: Date?
    @State private var accumulatedPauseDuration: TimeInterval = 0
    @State private var showCheckInSheet = false
    @State private var manualCode: String = ""
    @State private var selectedPoint: TrailPoint?
    @State private var manualCodeError = false
    @State private var scannedQRCode: String = ""
    @State private var showResultPopup = false
    @State private var checkInResultSuccess = true
    @State private var visitedRecords: [VisitedCheckpointRecord] = []
    @State private var isQRScannerPresented = false
    @State private var pendingQRScan = false
    @State private var summaryRecord: TQCompetitionRecordPresentable?
    @State private var showVisitedToast = false
    @State private var showDemoPermissionAlert = false
    @State private var pendingDemoAction: CheckInAction?
    @State private var pendingDemoPoint: TrailPoint?
    @State private var demoAlertShownForQR = false
    @State private var demoAlertShownForBLE = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let totalDistance: Double
    private let coordinates: [CLLocationCoordinate2D]
    private let initialRegion: MKCoordinateRegion

    init(
        trailName: String,
        parkID: Int,
        points: [TrailPoint],
        onPresented: (() -> Void)? = nil,
        onSummaryDismiss: (() -> Void)? = nil
    ) {
        self.trailName = trailName
        self.parkID = parkID
        self.points = points
        self.onPresented = onPresented
        self.onSummaryDismiss = onSummaryDismiss
        let coords = points.map { $0.coordinate }
        coordinates = coords
        totalDistance = TrailDistanceCalculator.totalDistance(for: coords)
        let region = MKCoordinateRegion.boundingRegion(for: coords, padding: 0.01)
        self.initialRegion = region
        _region = State(initialValue: region)
    }

    var body: some View {
        ZStack(alignment: .top) {
            mapLayer
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                statusPanel
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                Spacer()

                HStack(alignment: .bottom, spacing: 16) {
                    Spacer()
                    pauseButton
                    if isPaused {
                        finishButton
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
                .animation(.easeInOut(duration: 0.45), value: isPaused)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            refreshElapsedTime(referenceDate: startDate)
            onPresented?()
        }
        .onReceive(timer) { _ in
            guard !isPaused else { return }
            refreshElapsedTime()
        }
        .sheet(isPresented: $showCheckInSheet, onDismiss: {
            guard !pendingQRScan else { return }
            selectedPoint = nil
            manualCode = ""
            manualCodeError = false
            scannedQRCode = ""
            showResultPopup = false
            restoreInitialRegion()
        }) {
            if let point = selectedPoint {
                checkInSheet(for: point)
            } else {
                EmptyView()
            }
        }
        .overlay {
            CheckInResultPopup(success: checkInResultSuccess, isVisible: $showResultPopup)
                .environment(\.palette, palette)
        }
        .alert(L10n.TrailActive.demoAlert,
               isPresented: $showDemoPermissionAlert) {
            Button(L10n.Common.gotIt, role: .cancel) {
                performPendingDemoCheckIn()
            }
        }
        .overlay(alignment: .center) {
            if showVisitedToast {
                VisitedToast(palette: palette)
                    .padding(.top, 24)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: showCheckInSheet) { isPresented in
            guard !isPresented, pendingQRScan else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isQRScannerPresented = true
            }
        }
        .fullScreenCover(isPresented: $isQRScannerPresented) {
            TQQRScannerView { code in
                scannedQRCode = code
                pendingQRScan = false
                isQRScannerPresented = false
                handleCheckIn(action: .qr)
            }
            .environment(\.palette, palette)
        }
        .onChange(of: isQRScannerPresented) { presented in
            if !presented {
                pendingQRScan = false
            }
        }
        .onChange(of: scenePhase) { newPhase in
            guard newPhase == .active else { return }
            refreshElapsedTime()
        }
        .sheet(item: $summaryRecord, onDismiss: {
            onSummaryDismiss?()
        }) { summary in
            NavigationStack {
                CompetitionSummaryView(
                    presentable: summary,
                    onClose: {
                        summaryRecord = nil
                    }
                )
                .environment(\.palette, palette)
            }
        }
    }

    @ViewBuilder
    private func checkInSheet(for point: TrailPoint) -> some View {
        let sheet = BottomSheetCheckInView(
            trailPoint: point,
            isDemoRoute: isDemoRoute,
            manualCode: $manualCode,
            isManualCodeInvalid: $manualCodeError,
            onClose: {
                showCheckInSheet = false
                manualCode = ""
                manualCodeError = false
                scannedQRCode = ""
                showResultPopup = false
                selectedPoint = nil
                pendingQRScan = false
                restoreInitialRegion()
            },
            onSelect: { action in
                handleCheckIn(action: action)
            },
            onRequestQRCode: {
                guard !isDemoRoute else { return }
                manualCode = ""
                manualCodeError = false
                scannedQRCode = ""
                showResultPopup = false
                pendingQRScan = true
                showCheckInSheet = false
            }
        )
        .environment(\.palette, palette)

        if #available(iOS 16.4, *) {
            sheet
                .presentationDetents([.height(365)])
                .presentationCornerRadius(32)
                .presentationDragIndicator(.visible)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        } else {
            sheet
                .presentationDetents([.height(365)])
                .presentationDragIndicator(.visible)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }

    private var mapLayer: some View {
        Map(coordinateRegion: $region, annotationItems: points) { point in
            MapAnnotation(coordinate: point.coordinate) {
                Button {
                    selectedPoint = point
                    manualCode = ""
                    manualCodeError = false
                    scannedQRCode = ""

                    let pointIndex = points.firstIndex(where: { $0.id == point.id }) ?? Int.max
                    let seq = point.sequenceNumber ?? pointIndex + 1
                    let isVisited = visitedRecords.contains(where: { $0.sequenceNumber == seq })

                    if isVisited {
                        showCheckInSheet = false
                        showResultPopup = false
                        showVisitedToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            showVisitedToast = false
                        }
                        selectedPoint = nil
                    } else {
                        showResultPopup = false
                        showCheckInSheet = true
                        focusOn(point)
                    }
                } label: {
                    VStack(spacing: 4) {
                        let pointIndex = points.firstIndex(where: { $0.id == point.id }) ?? Int.max
                        let seq = point.sequenceNumber ?? pointIndex + 1
                        let isVisited = visitedRecords.contains(where: { $0.sequenceNumber == seq })
                        let markerColor = isVisited ? palette.accent.tertiary.color : palette.accent.primary.color

                        Image(systemName: "flag.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.white)
                            .padding(6)
                            .background(markerColor)
                            .clipShape(Circle())
                            .shadow(color: markerColor.opacity(0.35), radius: 4, y: 2)

                        Text(point.name)
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func handleCheckIn(action: CheckInAction) {
        guard let point = selectedPoint else { return }

        switch action {
        case .code:
            let trimmedInput = manualCode.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedInput.isEmpty else { return }
            manualCode = trimmedInput

            if isDemoRoute {
                manualCodeError = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completeCheckIn(for: action, point: point)
                }
            } else {
                if let expected = point.manualCode?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !expected.isEmpty {
                    if trimmedInput.compare(expected, options: .caseInsensitive) == .orderedSame {
                        completeCheckIn(for: action, point: point)
                    } else {
                        manualCodeError = true
                        checkInResultSuccess = false
                        showResultPopup = false
                    }
                } else {
                    completeCheckIn(for: action, point: point)
                }
            }

        case .qr:
            if isDemoRoute {
                if demoAlertShownForQR {
                    completeCheckIn(for: action, point: point)
                } else {
                    pendingDemoAction = .qr
                    pendingDemoPoint = point
                    showDemoPermissionAlert = true
                }
            } else {
                let trimmedCode = scannedQRCode.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedCode.isEmpty else {
                    presentFailedQRResult()
                    return
                }

                if let expectedQR = point.qrCode?.trimmingCharacters(in: .whitespacesAndNewlines),
                   !expectedQR.isEmpty,
                   trimmedCode.compare(expectedQR, options: .caseInsensitive) != .orderedSame {
                    presentFailedQRResult()
                    return
                }

                completeCheckIn(for: action, point: point)
            }

        case .ble:
            if isDemoRoute {
                if demoAlertShownForBLE {
                    completeCheckIn(for: action, point: point)
                } else {
                    pendingDemoAction = .ble
                    pendingDemoPoint = point
                    showDemoPermissionAlert = true
                }
            } else {
                completeCheckIn(for: action, point: point)
            }
        }
    }

    private func completeCheckIn(for action: CheckInAction, point: TrailPoint) {
        pendingQRScan = false
        addVisitedRecord(for: point, action: action)
        manualCode = ""
        manualCodeError = false
        scannedQRCode = ""
        showCheckInSheet = false
        selectedPoint = nil
        restoreInitialRegion()
        showCheckInResult(success: true)
    }

    private func presentFailedQRResult() {
        pendingQRScan = false
        checkInResultSuccess = false
        scannedQRCode = ""
        isQRScannerPresented = false
        showCheckInSheet = false
        selectedPoint = nil
        restoreInitialRegion()
        DispatchQueue.main.async {
            showResultPopup = true
        }
    }

    private var isDemoRoute: Bool {
        parkID == 1
    }

    private func addVisitedRecord(for point: TrailPoint, action: CheckInAction) {
        let sequenceIndex = points.firstIndex(where: { $0.id == point.id }) ?? 0
        let sequenceNumber = point.sequenceNumber ?? sequenceIndex + 1

        guard !visitedRecords.contains(where: { $0.sequenceNumber == sequenceNumber }) else { return }

        let record = VisitedCheckpointRecord(
            checkpointID: point.checkpointID ?? sequenceNumber,
            sequenceNumber: sequenceNumber,
            visitedAt: Date(),
            latitude: point.coordinate.latitude,
            longitude: point.coordinate.longitude,
            checkpointName: point.name,
            source: source(for: action)
        )

        visitedRecords.append(record)
        visitedRecords.sort { $0.sequenceNumber < $1.sequenceNumber }
    }

    private func source(for action: CheckInAction) -> TQSource {
        switch action {
        case .code:
            return .manual
        case .qr:
            return .qr
        case .ble:
            return .beacon
        }
    }

    private var statusPanel: some View {
        TQStatusPanelView(
            title: trailName,
            elapsedTime: elapsedTime,
            visitedCount: visitedRecords.count,
            totalPoints: points.count,
            totalDistanceMeters: totalDistance
        )
    }

    private var pauseButton: some View {
        Button {
            togglePause()
        } label: {
            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(palette.background.base.color)
                .padding(24)
                .background(
                    Circle()
                        .fill(
                            palette.accent.primary.color
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                )
        }
        .buttonStyle(.plain)
    }

    private var finishButton: some View {
        Button {
            finishRoute()
        } label: {
            Image(systemName: "flag.checkered")
                .font(.system(size: 28, weight: .heavy))
                .foregroundStyle(Color.white)
                .padding(28)
                .background(
                    Circle()
                        .fill(
                            palette.accent.secondary.color
                        )
                        .overlay(
                            Circle()
                                .stroke(palette.accent.secondary.color.opacity(0.35), lineWidth: 2)
                        )
                        .shadow(color: palette.accent.secondary.color.opacity(0.25), radius: 12, y: 6)
                )
        }
        .buttonStyle(.plain)
    }

    private func focusOn(_ point: TrailPoint) {
        withAnimation(.easeInOut(duration: 0.6)) {
            region = MKCoordinateRegion(
                center: point.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
            )
        }
    }

    private func restoreInitialRegion() {
        withAnimation(.easeInOut(duration: 0.6)) {
            region = initialRegion
        }
    }

    private func showCheckInResult(success: Bool) {
        checkInResultSuccess = success
        guard success else { return }
        DispatchQueue.main.async {
            showResultPopup = true
        }
    }

    private func finishRoute() {
        let finishDate = Date()
        if isPaused, let pauseStartedAt {
            accumulatedPauseDuration += finishDate.timeIntervalSince(pauseStartedAt)
            self.pauseStartedAt = nil
        }

        isPaused = true
        refreshElapsedTime(referenceDate: finishDate)
        pauseStartedAt = finishDate

        let orderedVisited = visitedRecords.sorted { $0.sequenceNumber < $1.sequenceNumber }
        let progress = points.isEmpty ? 0 : Double(orderedVisited.count) / Double(points.count)

        let record = CompetitionRecord(
            competitionUID: UUID().uuidString,
            parkID: parkID,
            parkName: trailName,
            startDate: startDate,
            finishDate: finishDate,
            totalCheckpoints: points.count,
            visitedCheckpoints: orderedVisited,
            lastUpdatedAt: finishDate,
            progress: progress,
            difficulty: .medium
        )

        Task {
            try? await competitionStore.create(record)
            await MainActor.run {
                summaryRecord = TQCompetitionRecordPresentable(record: record)
            }
        }
    }

    private func togglePause() {
        if isPaused {
            if let pauseStartedAt {
                accumulatedPauseDuration += Date().timeIntervalSince(pauseStartedAt)
                self.pauseStartedAt = nil
            }
            isPaused = false
            refreshElapsedTime()
        } else {
            pauseStartedAt = Date()
            isPaused = true
            refreshElapsedTime(referenceDate: pauseStartedAt ?? Date())
        }
    }

    private func refreshElapsedTime(referenceDate: Date = Date()) {
        let referenceMoment = isPaused ? (pauseStartedAt ?? referenceDate) : referenceDate
        let activeInterval = referenceMoment.timeIntervalSince(startDate) - accumulatedPauseDuration
        elapsedTime = max(0, activeInterval)
    }

    private func performPendingDemoCheckIn() {
        guard
            let action = pendingDemoAction,
            let point = pendingDemoPoint ?? selectedPoint
        else {
            pendingDemoAction = nil
            pendingDemoPoint = nil
            return
        }

        pendingDemoAction = nil
        pendingDemoPoint = nil

        if action == .qr {
            demoAlertShownForQR = true
        } else if action == .ble {
            demoAlertShownForBLE = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completeCheckIn(for: action, point: point)
        }
    }
}

private struct VisitedToast: View {
    let palette: TQPalette

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "trophy.circle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(palette.accent.secondary.color)

            Text(L10n.TrailActive.alreadyVisited)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(palette.text.primary.color)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: palette.background.base.color.opacity(0.2), radius: 8, y: 4)
        )
    }
}

#Preview {
    struct PreviewStore: CompetitionStore {
        func create(_ record: CompetitionRecord) async throws {}
        func delete(id: UUID) async throws {}
        func deleteAll() async throws {}
        func fetchPage(offset: Int, limit: Int) async throws -> [CompetitionRecord] { [] }
        func changes() -> AsyncStream<CompetitionChange> { AsyncStream { $0.finish() } }
    }

    return TrailActiveView(
        trailName: "Стартовая петля",
        parkID: 1,
        points: [
            TrailPoint(checkpointID: 1, sequenceNumber: 1, name: "Старт", coordinate: .init(latitude: 55.7558, longitude: 37.6176), beaconID: "BEACON-START", manualCode: "1111", qrCode: "START-QR"),
            TrailPoint(checkpointID: 2, sequenceNumber: 2, name: "Сосновая роща", coordinate: .init(latitude: 55.759, longitude: 37.62), beaconID: "BEACON-FOREST", manualCode: "2222", qrCode: "FOREST-QR"),
            TrailPoint(checkpointID: 3, sequenceNumber: 3, name: "Набережная", coordinate: .init(latitude: 55.753, longitude: 37.605), beaconID: "BEACON-RIVER", manualCode: "3333", qrCode: "RIVER-QR")
        ]
    )
    .environment(\.palette, TQPalette())
    .environment(\.competitionStore, PreviewStore())
}
