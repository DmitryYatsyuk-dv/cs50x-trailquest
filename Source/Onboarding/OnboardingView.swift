//
// OnboardingView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

@MainActor
struct OnboardingView: View {
    @Environment(\.palette) private var palette
    private let onFinish: (() -> Void)?

    @StateObject private var viewModel = OnboardingViewModel()
    @State private var subtitleOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var shimmerPhase: CGFloat = -1

    init(onFinish: (() -> Void)? = nil) {
        self.onFinish = onFinish
    }

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                Spacer(minLength: 24)

                pagesCarousel

                Spacer()
                    .frame(height: 60)

                actionSection
            }
            .opacity(viewModel.showSplash ? 0 : 1)

            splashOverlay
                .opacity(viewModel.showSplash ? 1 : 0)
                .animation(.easeOut(duration: 0.45), value: viewModel.showSplash)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.handleTap(onFinish: handleStart)
        }
        .overlay(alignment: .bottomTrailing) {
            if let icon = currentIcon {
                PulsingCornerIcon(icon: icon, color: currentAccent, palette: palette)
                    .padding(.trailing, 24)
                    .padding(.bottom, 120)
                    .opacity(viewModel.showSplash ? 0 : subtitleOpacity)
            }
        }
        .onAppear {
            viewModel.configure(with: palette)
            viewModel.startSplash()
            startShimmer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                startIntro()
            }
        }
    }

    private var pagesCarousel: some View {
        GeometryReader { geometry in
            VStack(spacing: 32) {
                pager(in: geometry.size)

                indicators
            }
        }
    }

    private func pager(in size: CGSize) -> some View {
        HStack(spacing: 0) {
            ForEach(viewModel.pages) { page in
                OnboardingPageView(page: page, palette: palette)
                    .frame(width: size.width)
            }
        }
        .offset(x: -CGFloat(viewModel.currentPage) * size.width + viewModel.offset)
        .animation(viewModel.isDragging ? nil : .spring(response: 0.6, dampingFraction: 0.8), value: viewModel.currentPage)
        .gesture(
            DragGesture()
                .onChanged { value in
                    viewModel.handleDragChanged(value.translation.width)
                }
                .onEnded { value in
                    viewModel.handleDragEnded(value.translation.width, containerWidth: size.width)
                }
        )
        .opacity(subtitleOpacity)
    }

    private var indicators: some View {
        HStack(spacing: 12) {
            ForEach(viewModel.pages.indices, id: \.self) { index in
                Capsule()
                    .fill(index == viewModel.currentPage ? currentAccent : palette.background.group.color)
                    .frame(width: index == viewModel.currentPage ? 32 : 8, height: 8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: viewModel.currentPage)
            }
        }
        .opacity(subtitleOpacity)
    }

    private var actionSection: some View {
        VStack(spacing: 30) {
            navigationButtons
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }

    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if viewModel.currentPage > 0 {
                Button(action: viewModel.goBack) {
                    Text(L10n.Onboarding.back)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(currentAccent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(palette.background.card.color)
                                .shadow(color: palette.utility.border.color.opacity(0.25), radius: 8, y: 4)
                        )
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            }

            Button(action: { viewModel.goForward(onFinish: handleStart) }) {
                HStack(spacing: 8) {
                    Text(viewModel.isLastPage ? L10n.Onboarding.start : L10n.Onboarding.next)
                        .font(.system(size: 17, weight: .semibold))

                    Image(systemName: viewModel.isLastPage ? "checkmark" : "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(palette.background.base.color)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    currentAccent,
                                    currentAccent.opacity(0.85)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: currentAccent.opacity(0.4), radius: 12, y: 6)
                )
            }
        }
        .opacity(buttonOpacity)
    }

    private var currentAccent: Color {
        viewModel.pages.indices.contains(viewModel.currentPage) ? viewModel.currentAccent : palette.accent.primary.color
    }

    private var currentIcon: String? {
        guard viewModel.pages.indices.contains(viewModel.currentPage) else { return nil }
        return viewModel.pages[viewModel.currentPage].icon
    }

    private var background: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [
                    currentAccent.opacity(0.25),
                    currentAccent.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .animation(.easeInOut(duration: 0.6), value: currentAccent)
            .ignoresSafeArea()
        }
    }

    private func startIntro() {
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            subtitleOpacity = 1.0
        }

        withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
            buttonOpacity = 1.0
        }
    }

    private func handleStart() {
        onFinish?()
    }

    private func startShimmer() {
        shimmerPhase = -1
        withAnimation(.linear(duration: 2.2).repeatForever(autoreverses: false)) {
            shimmerPhase = 1.2
        }
    }
}

private extension OnboardingView {
    var splashOverlay: some View {
        ZStack {
            LinearGradient(
                colors: [
                    palette.background.base.color
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            splashTitle
                .padding()
        }
    }

    private var splashTitle: some View {
        let base = Text(L10n.App.name)
            .font(.system(size: 52, weight: .bold, design: .rounded))
            .foregroundStyle(palette.text.primary.color)
            .shadow(color: palette.background.selection.color.opacity(0.35), radius: 12, y: 6)
            .shadow(color: palette.background.base.color.opacity(0.5), radius: 5, y: 0)

        return base
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            palette.background.base.color.opacity(0.0),
                            palette.background.base.color.opacity(0.55),
                            palette.accent.tertiary.color.opacity(0.9),
                            palette.background.base.color.opacity(0.55),
                            palette.background.base.color.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: geo.size.width * 1.6, height: geo.size.height)
                    .rotationEffect(.degrees(20))
                    .offset(x: shimmerPhase * geo.size.width)
                }
            )
            .mask(base)
    }
}

private struct PulsingCornerIcon: View {
    let icon: String
    let color: Color
    let palette: TQPalette
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.15))
                .frame(width: 45, height: 45)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true), value: isAnimating)

            Circle()
                .fill(color.opacity(0.12))
                .frame(width: 34, height: 34)

            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.white)
        }
        .shadow(color: palette.utility.border.color.opacity(0.25), radius: 6, y: 3)
        .onAppear { isAnimating = true }
    }
}

#Preview {
    OnboardingView()
        .environment(\.palette, TQPalette())
}
