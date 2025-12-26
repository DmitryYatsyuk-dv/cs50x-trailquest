// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum App {
    /// TrailQuest
    internal static let name = L10n.tr("Localizable", "app.name")
  }

  internal enum Checkin {
    internal enum Ble {
      /// BLE недоступен
      internal static let alertTitle = L10n.tr("Localizable", "checkin.ble.alert_title")
      /// Подтвердить отметку
      internal static let confirm = L10n.tr("Localizable", "checkin.ble.confirm")
      /// Маяк найден
      internal static let found = L10n.tr("Localizable", "checkin.ble.found")
      /// Разрешите доступ к геопозиции, чтобы отслеживать BLE-маячки и подтверждать посещение точки.
      internal static let permissionMessage = L10n.tr("Localizable", "checkin.ble.permission_message")
      /// Держите устройство рядом с контрольной точкой. Как только маяк будет найден, отметка станет доступной.
      internal static let searchMessage = L10n.tr("Localizable", "checkin.ble.search_message")
      /// Поиск BLE-маячка
      internal static let searchTitle = L10n.tr("Localizable", "checkin.ble.search_title")
      /// Идёт поиск BLE-маячка поблизости…
      internal static let searching = L10n.tr("Localizable", "checkin.ble.searching")
      /// Использует BLE-маячок рядом
      internal static let subtitle = L10n.tr("Localizable", "checkin.ble.subtitle")
      /// Автоматическая отметка
      internal static let title = L10n.tr("Localizable", "checkin.ble.title")
      /// Автоматическая отметка (демо)
      internal static let titleDemo = L10n.tr("Localizable", "checkin.ble.title_demo")
    }
    internal enum Demo {
      /// Демо режим. Для демонстрации точки отмечаются автоматически.
      internal static let note = L10n.tr("Localizable", "checkin.demo.note")
    }
    internal enum Manual {
      /// Неверный код. Попробуйте снова.
      internal static let invalid = L10n.tr("Localizable", "checkin.manual.invalid")
      /// Например, 1284
      internal static let placeholder = L10n.tr("Localizable", "checkin.manual.placeholder")
      /// Ввести код
      internal static let title = L10n.tr("Localizable", "checkin.manual.title")
    }
    internal enum Qr {
      /// Наведите камеру на код
      internal static let subtitle = L10n.tr("Localizable", "checkin.qr.subtitle")
      /// Отметиться по QR
      internal static let title = L10n.tr("Localizable", "checkin.qr.title")
      /// Отметиться по QR (демо)
      internal static let titleDemo = L10n.tr("Localizable", "checkin.qr.title_demo")
    }
    internal enum Result {
      /// Не удалось отметить
      internal static let failure = L10n.tr("Localizable", "checkin.result.failure")
      /// Попробуйте снова
      internal static let retry = L10n.tr("Localizable", "checkin.result.retry")
      /// Посещено!
      internal static let success = L10n.tr("Localizable", "checkin.result.success")
    }
    internal enum Sheet {
      /// Отметьтесь на контрольной точке,
      /// одним из способов
      internal static let subtitle = L10n.tr("Localizable", "checkin.sheet.subtitle")
    }
  }

  internal enum Common {
    /// Отменить
    internal static let cancel = L10n.tr("Localizable", "common.cancel")
    /// Закрыть
    internal static let close = L10n.tr("Localizable", "common.close")
    /// Удалить
    internal static let delete = L10n.tr("Localizable", "common.delete")
    /// Понятно
    internal static let gotIt = L10n.tr("Localizable", "common.got_it")
    /// OK
    internal static let ok = L10n.tr("Localizable", "common.ok")
    /// Настройки
    internal static let settings = L10n.tr("Localizable", "common.settings")
  }

  internal enum Distance {
    /// %.1f км
    internal static func km(_ p1: Float) -> String {
      return L10n.tr("Localizable", "distance.km", p1)
    }
  }

  internal enum Duration {
    /// 00:00:00
    internal static let zeroLong = L10n.tr("Localizable", "duration.zero_long")
    /// 00:00
    internal static let zeroShort = L10n.tr("Localizable", "duration.zero_short")
  }

  internal enum History {
    /// Здесь появится
    /// история соревнований
    internal static let empty = L10n.tr("Localizable", "history.empty")
    /// посещено %d из %d
    internal static func progress(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "history.progress", p1, p2)
    }
    /// История
    internal static let title = L10n.tr("Localizable", "history.title")
  }

  internal enum Onboarding {
    /// Назад
    internal static let back = L10n.tr("Localizable", "onboarding.back")
    /// Далее
    internal static let next = L10n.tr("Localizable", "onboarding.next")
    /// Начать
    internal static let start = L10n.tr("Localizable", "onboarding.start")
    internal enum Page1 {
      /// Выбирай прогулочные, спортивные и культурные маршруты в парках и районах города. Каждый маршрут — это путь с интересными точками и историей.
      internal static let description = L10n.tr("Localizable", "onboarding.page1.description")
      /// Открывай новые маршруты
      internal static let title = L10n.tr("Localizable", "onboarding.page1.title")
    }
    internal enum Page2 {
      /// Отмечай посещение точек с помощью QR-кодов, BLE-маячков или вручную. Несколько способов отметки делают путешествие удобным и интерактивным.
      internal static let description = L10n.tr("Localizable", "onboarding.page2.description")
      /// Проходи чекпоинты по-разному
      internal static let title = L10n.tr("Localizable", "onboarding.page2.title")
    }
    internal enum Page3 {
      /// Карта показывает твой прогресс: пройденные точки, расстояние и время. Ты всегда знаешь, что уже сделал и что впереди.
      internal static let description = L10n.tr("Localizable", "onboarding.page3.description")
      /// Видишь весь маршрут перед собой
      internal static let title = L10n.tr("Localizable", "onboarding.page3.title")
    }
    internal enum Page4 {
      /// История маршрутов сохраняется на устройстве. Делись результатами с друзьями, семьёй или командой.
      internal static let description = L10n.tr("Localizable", "onboarding.page4.description")
      /// Сохраняй и делись достижениями
      internal static let title = L10n.tr("Localizable", "onboarding.page4.title")
    }
  }

  internal enum Profile {
    /// Удалить профиль
    internal static let delete = L10n.tr("Localizable", "profile.delete")
    /// Сохранить
    internal static let save = L10n.tr("Localizable", "profile.save")
    /// Профиль
    internal static let title = L10n.tr("Localizable", "profile.title")
    internal enum Camera {
      /// Похоже, камера недоступна на этом устройстве.
      internal static let unavailableMessage = L10n.tr("Localizable", "profile.camera.unavailable_message")
      /// Камера недоступна
      internal static let unavailableTitle = L10n.tr("Localizable", "profile.camera.unavailable_title")
    }
    internal enum Delete {
      /// Это удалит все сохранённые данные и фото профиля.
      internal static let confirmMessage = L10n.tr("Localizable", "profile.delete.confirm_message")
      /// Удалить профиль?
      internal static let confirmTitle = L10n.tr("Localizable", "profile.delete.confirm_title")
    }
    internal enum Name {
      /// Имя
      internal static let label = L10n.tr("Localizable", "profile.name.label")
    }
    internal enum Photo {
      /// Сделайте фото или выберите изображение из галереи
      internal static let hint = L10n.tr("Localizable", "profile.photo.hint")
      /// Выбрать из галереи
      internal static let pick = L10n.tr("Localizable", "profile.photo.pick")
      /// Сделать фото
      internal static let take = L10n.tr("Localizable", "profile.photo.take")
      /// Обновить фото
      internal static let update = L10n.tr("Localizable", "profile.photo.update")
      /// Обновить фото профиля
      internal static let updateTitle = L10n.tr("Localizable", "profile.photo.update_title")
    }
    internal enum Save {
      /// Сохранено
      internal static let success = L10n.tr("Localizable", "profile.save.success")
    }
  }

  internal enum Qr {
    /// QR обнаружен
    internal static let detected = L10n.tr("Localizable", "qr.detected")
    /// Наведите камеру на QR-код контрольной точки
    internal static let instruction = L10n.tr("Localizable", "qr.instruction")
    internal enum Alert {
      /// Нет доступа к камере
      internal static let title = L10n.tr("Localizable", "qr.alert.title")
    }
    internal enum Banner {
      /// Сканируем…
      internal static let scanning = L10n.tr("Localizable", "qr.banner.scanning")
    }
    internal enum Camera {
      /// Не удалось настроить камеру
      internal static let configureFailed = L10n.tr("Localizable", "qr.camera.configure_failed")
      /// Камера недоступна
      internal static let unavailable = L10n.tr("Localizable", "qr.camera.unavailable")
    }
    internal enum Permission {
      /// Разрешите доступ к камере, чтобы сканировать QR-коды.
      internal static let defaultMessage = L10n.tr("Localizable", "qr.permission.default_message")
      /// Доступ к камере отклонён
      internal static let denied = L10n.tr("Localizable", "qr.permission.denied")
      /// Включите доступ к камере в настройках
      internal static let settings = L10n.tr("Localizable", "qr.permission.settings")
    }
  }

  internal enum Summary {
    /// Я прошёл маршрут %@: %@, время %@.
    internal static func shareText(_ p1: Any, _ p2: Any, _ p3: Any) -> String {
      return L10n.tr("Localizable", "summary.share_text", String(describing: p1), String(describing: p2), String(describing: p3))
    }
  }

  internal enum Tab {
    /// История
    internal static let history = L10n.tr("Localizable", "tab.history")
    /// Профиль
    internal static let profile = L10n.tr("Localizable", "tab.profile")
    /// Маршруты
    internal static let routes = L10n.tr("Localizable", "tab.routes")
  }

  internal enum TrailActive {
    /// Вы уже посетили эту локацию!
    internal static let alreadyVisited = L10n.tr("Localizable", "trail_active.already_visited")
    /// Для демонстрации приложение использует тестовый режим.
    /// В реальном маршруте потребуется разрешение Bluetooth и камеры.
    internal static let demoAlert = L10n.tr("Localizable", "trail_active.demo_alert")
  }

  internal enum TrailDetail {
    /// Число контрольных точек: %d
    internal static func pointsCount(_ p1: Int) -> String {
      return L10n.tr("Localizable", "trail_detail.points_count", p1)
    }
    /// Старт
    internal static let start = L10n.tr("Localizable", "trail_detail.start")
  }

  internal enum TrailList {
    /// Не удалось отобразить данные
    internal static let failure = L10n.tr("Localizable", "trail_list.failure")
    /// Маршруты
    internal static let title = L10n.tr("Localizable", "trail_list.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    return Bundle.main
  }()
}
// swiftlint:enable convenience_type
