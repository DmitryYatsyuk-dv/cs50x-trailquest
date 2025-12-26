//
// OnboardingPageView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let palette: TQPalette

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                illustrationBlock(geometry: geometry)

                Spacer(
                    minLength: page.illustrationView == .horizontally ? .zero : 20
                )

                ContentView(page: page, palette: palette)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                    .layoutPriority(1)

                Spacer(minLength: 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Illustration

    private func illustrationBlock(
        geometry: GeometryProxy
    ) -> some View {

        return Group {
            if page.illustrationView == .horizontally {
                IllustrationView(
                    assetName: page.assetName,
                    isVertical: false
                )
                .frame(height: geometry.size.height * 0.56)
            } else {
                IllustrationView(
                    assetName: page.assetName,
                    isVertical: true
                )
                .frame(height: geometry.size.height * 0.66)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, geometry.safeAreaInsets.top + (page.illustrationView == .vertically ? 0 : 30))
    }
}

// MARK: - IllustrationView

private struct IllustrationView: View {
    let assetName: String
    let isVertical: Bool

    var body: some View {
        Image(assetName, bundle: TQBundleHelper.bundle)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
    }
}

// MARK: - Content

private struct ContentView: View {
    let page: OnboardingPage
    let palette: TQPalette

    var body: some View {
        VStack(spacing: 16) {
            Text(page.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(palette.text.primary.color)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            Text(page.description)
                .font(.system(size: 17, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(palette.text.secondary.color)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
