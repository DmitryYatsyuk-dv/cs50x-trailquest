//
// OnboardingViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var pages: [OnboardingPage] = []
    @Published var currentPage: Int = 0
    @Published var offset: CGFloat = 0
    @Published var isDragging: Bool = false
    @Published var showSplash: Bool = true

    func configure(with palette: TQPalette) {
        guard pages.isEmpty else { return }
        pages = OnboardingPage.defaultPages(palette: palette)
    }

    var currentAccent: Color {
        guard pages.indices.contains(currentPage) else { return .accentColor }
        return pages[currentPage].accent
    }

    var isLastPage: Bool {
        guard !pages.isEmpty else { return true }
        return currentPage >= pages.count - 1
    }

    func handleDragChanged(_ translation: CGFloat) {
        isDragging = true
        offset = translation
    }

    func handleDragEnded(_ translation: CGFloat, containerWidth: CGFloat) {
        isDragging = false
        let threshold = containerWidth * 0.2

        if translation < -threshold, currentPage < pages.count - 1 {
            currentPage += 1
        } else if translation > threshold, currentPage > 0 {
            currentPage -= 1
        }
        offset = 0
    }

    func goBack() {
        guard currentPage > 0 else { return }
        withAnimation {
            currentPage -= 1
        }
    }

    func goForward(onFinish: () -> Void) {
        withAnimation {
            if currentPage < pages.count - 1 {
                currentPage += 1
            } else {
                onFinish()
            }
        }
    }

    func handleTap(onFinish: () -> Void) {
        guard !showSplash else { return }
        goForward(onFinish: onFinish)
    }

    func startSplash(duration: TimeInterval = 1.4, fade: TimeInterval = 0.6) {
        showSplash = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            withAnimation(.easeOut(duration: fade)) {
                showSplash = false
            }
        }
    }
}
