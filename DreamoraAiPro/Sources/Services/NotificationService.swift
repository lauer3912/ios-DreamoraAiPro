import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()
    private let dreamReminderID = "com.ggsheng.DreamoraAiPro.dreamReminder"

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in DispatchQueue.main.async { completion(granted) } }
    }

    func scheduleDreamReminder(at hour: Int = 22) {
        center.removePendingNotificationRequests(withIdentifiers: [dreamReminderID])
        let content = UNMutableNotificationContent()
        content.title = "🌙 DreamoraAiPro"
        content.body = "Before you sleep, log your dreams! Discover what your subconscious is telling you."
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: hour, minute: 0), repeats: true)
        let request = UNNotificationRequest(identifier: dreamReminderID, content: content, trigger: trigger)
        center.add(request) { error in if let e = error { print("Notification error: \(e)") } }
    }

    func cancelAll() { center.removePendingNotificationRequests(withIdentifiers: [dreamReminderID]) }
    var isEnabled: Bool { get { UserDefaults.standard.bool(forKey: "DreamoraAiPro.notificationsEnabled") } set { UserDefaults.standard.set(newValue, forKey: "DreamoraAiPro.notificationsEnabled") } }

    func toggle(enabled: Bool, completion: @escaping (Bool) -> Void) {
        if enabled { requestAuthorization { [weak self] granted in if granted { self?.isEnabled = true; self?.scheduleDreamReminder(); completion(true) } else { completion(false) } } }
        else { isEnabled = false; cancelAll(); completion(true) }
    }
    func restoreScheduledNotifications() { if isEnabled { scheduleDreamReminder() } }
}
