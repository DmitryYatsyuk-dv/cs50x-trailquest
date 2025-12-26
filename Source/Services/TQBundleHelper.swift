//
// TQBundleHelper.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

final class TQBundleHelper {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: TQBundleHelper.self)
    #endif
  }()
}
