//
// CheckInResultPopup.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct CheckInResultPopup: View {
    @Environment(\.palette) private var palette

    let success: Bool
    @Binding var isVisible: Bool
    @State private var hideWorkItem: DispatchWorkItem?
    @State private var blurOpacity: Double = 0
    @State private var dissolveScale: CGFloat = 1
    @State private var dissolveOpacity: Double = 1
    @State private var dissolveBlur: CGFloat = 0

    var body: some View {
        ZStack {
            if isVisible {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .opacity(blurOpacity)
                    .transition(.opacity)
                    .onTapGesture {
                        hidePopup()
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            blurOpacity = 0.85
                        }
                    }
                    .onDisappear {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            blurOpacity = 0
                        }
                    }

                // 🌫 Попап с эффектом “растворения”
                popupContent
                    .scaleEffect(dissolveScale)
                    .opacity(dissolveOpacity)
                    .blur(radius: dissolveBlur)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        animateAppear()
                        scheduleAutoHide()
                    }
                    .onDisappear {
                        hideWorkItem?.cancel()
                        hideWorkItem = nil
                    }
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.8), value: isVisible)
    }

    private var popupContent: some View {
        VStack(spacing: 12) {
            resultIcon
                .shadow(color: Color.black.opacity(0.15), radius: 8, y: 4)

            Text(success ? L10n.Checkin.Result.success : L10n.Checkin.Result.failure)
                .font(.headline.weight(.semibold))
                .foregroundStyle(palette.text.primary.color)

            if !success {
                Text(L10n.Checkin.Result.retry)
                    .font(.subheadline)
                    .foregroundStyle(palette.text.secondary.color)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 26)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(palette.background.card.color)
        )
        .shadow(color: palette.background.base.color.opacity(0.35), radius: 18, y: 8)
    }

    // MARK: - Анимации

    private func animateAppear() {
        // Появление — лёгкий zoom-in
        dissolveScale = 0.92
        dissolveOpacity = 0
        dissolveBlur = 6

        withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
            dissolveScale = 1.0
            dissolveOpacity = 1.0
            dissolveBlur = 0
        }
    }

    private func scheduleAutoHide() {
        hideWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            hidePopup()
        }
        hideWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItem)
    }

    private func resetState() {
        dissolveScale = 1
        dissolveOpacity = 1
        dissolveBlur = 0
        blurOpacity = 0
    }

    private func hidePopup() {
        guard isVisible else { return }
        hideWorkItem?.cancel()
        hideWorkItem = nil

        withAnimation(.easeInOut(duration: 0.35)) {
            dissolveScale = 1.05
            dissolveBlur = 12
            dissolveOpacity = 0
            blurOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            isVisible = false
            resetState()
        }
    }

    @ViewBuilder
    private var resultIcon: some View {
        Image(systemName: success ? "checkmark.circle.fill" : "xmark.octagon.fill")
            .font(.system(size: 56))
            .foregroundStyle(success ? palette.accent.primary.color : palette.utility.error.color)
            .scaleEffect(isVisible ? 1.1 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isVisible)
    }
}

#Preview {
    ZStack {
        Color(.systemBackground)
        CheckInResultPopup(success: true, isVisible: .constant(true))
    }
    .environment(\.palette, TQPalette())
}
