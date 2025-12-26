//
// TQProfileFormSection.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQProfileFormSection: View {
    let palette: TQPalette
    @Binding var name: String
    var focusedField: FocusState<TQProfileFocusField?>.Binding

    private var isNameFocused: Bool {
        focusedField.wrappedValue == .name
    }

    var body: some View {
        VStack(spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.Profile.Name.label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(palette.text.secondary.color)

                TextField("", text: $name)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(palette.background.group.color.opacity(0.65))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isNameFocused ?
                                    palette.accent.primary.color.opacity(0.8) :
                                    palette.utility.border.color.opacity(0.3),
                                lineWidth: 1.2
                            )
                    )
                    .keyboardType(.default)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .name)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField.wrappedValue = nil
                    }
            }
            .foregroundStyle(palette.text.primary.color)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(palette.background.groupElement.color)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(palette.utility.border.color, lineWidth: 1)
        )
//        .shadow(color: palette.background.group.color.opacity(0.25), radius: 12, y: 6)
    }
}

#Preview {
    ProfileFormSectionPreview()
        .environment(\.palette, TQPalette())
}

private struct ProfileFormSectionPreview: View {
    @State private var name: String = ""
    @FocusState private var focus: TQProfileFocusField?

    var body: some View {
        TQProfileFormSection(
            palette: TQPalette(),
            name: $name,
            focusedField: $focus
        )
    }
}
