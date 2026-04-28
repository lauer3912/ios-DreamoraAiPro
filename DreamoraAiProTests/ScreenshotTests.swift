import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Screenshot Helper

    func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
    }

    // MARK: - Tab Navigation Helper

    func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists {
            button.tap()
            Thread.sleep(forTimeInterval: 1.5)
        } else {
            print("WARNING: Could not find tab button: \(identifier)")
        }
    }

    // MARK: - iPhone 6.9" (1320×2868) - iPhone 16 Pro Max

    func testiPhone_69_01_Home() {
        capture("iPhone_69_portrait_01_Home")
    }

    func testiPhone_69_02_Journal() {
        tapTab(identifier: "tab_journal")
        capture("iPhone_69_portrait_02_Journal")
    }

    func testiPhone_69_03_Sleep() {
        tapTab(identifier: "tab_sleep")
        capture("iPhone_69_portrait_03_Sleep")
    }

    func testiPhone_69_04_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_69_portrait_04_Settings")
    }

    // MARK: - iPhone 6.5" (1284×2778) - iPhone 14 Plus

    func testiPhone_65_01_Home() {
        capture("iPhone_65_portrait_01_Home")
    }

    func testiPhone_65_02_Journal() {
        tapTab(identifier: "tab_journal")
        capture("iPhone_65_portrait_02_Journal")
    }

    func testiPhone_65_03_Sleep() {
        tapTab(identifier: "tab_sleep")
        capture("iPhone_65_portrait_03_Sleep")
    }

    func testiPhone_65_04_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_65_portrait_04_Settings")
    }

    // MARK: - iPhone 6.3" (1206×2622) - iPhone 16 Pro

    func testiPhone_63_01_Home() {
        capture("iPhone_63_portrait_01_Home")
    }

    func testiPhone_63_02_Journal() {
        tapTab(identifier: "tab_journal")
        capture("iPhone_63_portrait_02_Journal")
    }

    func testiPhone_63_03_Sleep() {
        tapTab(identifier: "tab_sleep")
        capture("iPhone_63_portrait_03_Sleep")
    }

    func testiPhone_63_04_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_63_portrait_04_Settings")
    }

    // MARK: - iPad 13" (2048×2732) - iPad Pro 13-inch (M4)

    func testiPad_13_01_Home() {
        capture("iPad_13_portrait_01_Home")
    }

    func testiPad_13_02_Journal() {
        tapTab(identifier: "tab_journal")
        capture("iPad_13_portrait_02_Journal")
    }

    func testiPad_13_03_Sleep() {
        tapTab(identifier: "tab_sleep")
        capture("iPad_13_portrait_03_Sleep")
    }

    func testiPad_13_04_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_13_portrait_04_Settings")
    }

    // MARK: - iPad 11" (1668×2388) - iPad Pro 11-inch (M4)

    func testiPad_11_01_Home() {
        capture("iPad_11_portrait_01_Home")
    }

    func testiPad_11_02_Journal() {
        tapTab(identifier: "tab_journal")
        capture("iPad_11_portrait_02_Journal")
    }

    func testiPad_11_03_Sleep() {
        tapTab(identifier: "tab_sleep")
        capture("iPad_11_portrait_03_Sleep")
    }

    func testiPad_11_04_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_11_portrait_04_Settings")
    }
}