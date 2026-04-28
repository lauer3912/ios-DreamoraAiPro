# DreamoraAiPro — Product Specification

## 1. Project Overview

- **App Name:** DreamoraAiPro
- **Bundle ID:** com.ggsheng.DreamoraAiPro
- **Core Functionality:** AI-powered sleep tracking, dream journaling, and personalized dream analysis with psychological insights.
- **Target Users:** Adults 25-45 in US/Europe interested in self-discovery, mental wellness, meditation, and dream exploration.
- **iOS Version Support:** iOS 17.0+
- **Language:** English only (no CJK)

---

## 2. UI/UX Specification

### Screen Structure

| Screen | Description |
|--------|-------------|
| **SplashView** | Animated starfield logo, transitions to MainTabView |
| **MainTabView** | 4 tabs: Home, Dream Journal, Sleep Tracker, Settings |
| **HomeView** | Dashboard: sleep score, recent dreams, quick add, mood ring |
| **DreamJournalView** | List of all dreams with filtering, search, tags |
| **DreamDetailView** | Full dream entry: text, audio, AI analysis, mood tags |
| **AddDreamView** | Record/type dream, voice input, save flow |
| **SleepTrackerView** | Weekly sleep chart, trends, HealthKit integration |
| **DreamAnalysisView** | AI analysis: emotions, symbols, themes, psychology insights |
| **SettingsView** | Account, subscription, notifications, privacy, theme |
| **PremiumView** | Subscription plans, features comparison |

### Navigation Structure
```
MainTabView (UITabBarController equivalent)
├── Tab 1: HomeView → DreamDetailView → DreamAnalysisView
├── Tab 2: DreamJournalView → DreamDetailView → AddDreamView
├── Tab 3: SleepTrackerView
└── Tab 4: SettingsView → PremiumView
```

### Visual Design

**Color Palette:**
- Background Primary: `#0B0F1A` (deep space black)
- Background Secondary: `#151B2E` (dark navy)
- Accent Primary: `#8B5CF6` (vivid purple)
- Accent Secondary: `#06B6D4` (cyan)
- Accent Gradient: `#8B5CF6` → `#06B6D4` (diagonal 135deg)
- Text Primary: `#FFFFFF`
- Text Secondary: `#94A3B8` (slate)
- Surface: `#1E293B` (card background)
- Success: `#10B981` (emerald)
- Warning: `#F59E0B` (amber)
- Error: `#EF4444` (red)

**Typography:**
- Headings: SF Pro Display, Bold
  - H1: 34pt, H2: 28pt, H3: 22pt
- Body: SF Pro Text, Regular, 17pt
- Caption: SF Pro Text, Regular, 13pt
- Numbers/Stats: SF Pro Rounded, Bold

**Spacing System (8pt grid):**
- XS: 4pt, S: 8pt, M: 16pt, L: 24pt, XL: 32pt, XXL: 48pt

**iOS-Specific:**
- Safe area respected on all screens
- Dynamic Island / Notch handled via native SwiftUI safe areas
- Haptic feedback on key interactions (recording start/stop, save)

### Views & Components

| Component | States | Behavior |
|-----------|--------|----------|
| DreamCard | default, selected, loading | Tap → navigate to detail |
| MoodRing | animated gradient ring | Shows current mood score 0-100 |
| SleepChart | bar chart, weekly | Tap bar → show day detail |
| AudioWaveform | animated bars during recording | Recording duration indicator |
| AIAnalysisCard | loading shimmer → result | Expandable sections |
| PremiumBadge | animated glow | Shown on premium-only features |
| TabBarIcon | filled/outlined variants | Haptic on selection |

---

## 3. Functionality Specification

### Core Features (Priority Order)

**P0 — Must Have:**
1. **Dream Recording** — Voice-to-text or manual text entry with timestamp
2. **Dream Storage** — Local persistence (SQLite), searchable by date/tag/mood
3. **AI Dream Analysis** — Mock AI analysis (emotion detection, symbol extraction, theme classification)
4. **Sleep Score** — Daily score 0-100 based on entry consistency and optional HealthKit data
5. **Dark Theme** — Full dark mode UI as primary

**P1 — Important:**
6. **Dream Tags & Mood** — Categorize dreams (lucid, nightmare, recurring) + mood (peaceful, anxious, excited)
7. **Weekly Sleep Chart** — Bar chart of sleep quality over 7 days
8. **Reminder Notifications** — "Record your dream" morning push
9. **Search & Filter** — Full-text search across dream journal

**P2 — Nice to Have:**
10. **Audio Recording** — Record voice memo attached to dream
11. **Dream Symbols Dictionary** — Common dream symbols with meanings
12. **Statistics Dashboard** — Total dreams, streak, most common mood
13. **Export Dreams** — Export as PDF/Markdown

### User Interactions & Flows

**Flow 1: Record Dream**
1. Tap "+" FAB on Home or Journal tab
2. Choose: Type / Voice Record
3. Enter dream text or record voice (speech-to-text)
4. Tag mood (5 options) + dream type (lucid/nightmare/recurring/normal)
5. Tap Save → AI analysis runs in background
6. Return to Home with new dream card

**Flow 2: View AI Analysis**
1. Open any dream detail
2. Tap "AI Analysis" section (if premium)
3. View: Emotion breakdown, Top symbols, Theme tags, Psychology insight
4. Swipe for more insights

**Flow 3: Check Sleep Trend**
1. Open Sleep Tracker tab
2. See weekly bar chart
3. Tap day for detail: dreams that night, sleep score, tips

### Data Handling

- **Local Storage:** SQLite.swift for dream entries
- **User Preferences:** UserDefaults for settings (notifications, theme preference)
- **HealthKit:** Optional read of sleep analysis data (not required)
- **No external API calls** — AI analysis is mock/simulated with deterministic results

### Architecture Pattern

**MVVM (Model-View-ViewModel)**
- Models: DreamEntry, SleepRecord, AnalysisResult, UserSettings
- ViewModels: DreamJournalViewModel, SleepTrackerViewModel, SettingsViewModel
- Views: SwiftUI views, purely declarative

### Edge Cases & Error Handling

- Empty state: No dreams yet → show onboarding prompt
- Voice recognition fails → show manual entry fallback
- Storage full → warn user, offer to export/delete old dreams
- Network unavailable → all features work offline (no sync needed)

---

## 4. Technical Specification

### Dependencies (Swift Package Manager)

| Package | Version | Purpose |
|---------|---------|---------|
| SQLite.swift | 0.15.3 | Local dream storage |
| SnapKit | 5.7.1 | Auto Layout (UIKit components if any) |

### UI Framework

- **SwiftUI** (primary, iOS 17+)
- UIKit only if absolutely needed for specific interactions

### Asset Requirements

**App Icon:**
- 1024x1024 app store icon
- Theme: Glowing purple nebula with star constellation forming "D" shape
- Must be provided by designer before build

**SF Symbols Used:**
- moon.fill, moon.stars.fill (sleep/dreams)
- plus.circle.fill (add dream)
- mic.fill (voice record)
- waveform (audio)
- chart.bar.fill (sleep tracker)
- gearshape.fill (settings)
- star.fill (premium badge)
- brain.head.profile (AI analysis)
- face.smiling (mood)

**Colors:**
- All colors defined in Assets.xcassets as named colors (Color Set)
- Support for light/dark (dark primary, light secondary override)

---

## 5. Subscription (StoreKit 2)

**Free Tier:**
- 3 dreams/month
- Basic sleep tracking
- Dream journal (limited)

**Premium ($4.99/month or $39.99/year):**
- Unlimited dreams
- AI Dream Analysis (full)
- Sleep trends & insights
- Audio recording
- Export dreams
- Priority support

**Implementation:**
- StoreKit 2 with Product IDs: `com.ggsheng.DreamoraAiPro.premium.monthly`, `com.ggsheng.DreamoraAiPro.premium.yearly`
- RevenueCat or manual StoreKit 2

---

## 6. File Structure

```
ios-DreamoraAiPro/
├── DreamoraAiPro/
│   ├── App/
│   │   └── DreamoraAiProApp.swift
│   ├── Models/
│   │   ├── DreamEntry.swift
│   │   ├── SleepRecord.swift
│   │   └── AnalysisResult.swift
│   ├── ViewModels/
│   │   ├── DreamJournalViewModel.swift
│   │   ├── SleepTrackerViewModel.swift
│   │   └── SettingsViewModel.swift
│   ├── Views/
│   │   ├── Main/
│   │   │   ├── MainTabView.swift
│   │   │   └── ContentView.swift
│   │   ├── Home/
│   │   │   └── HomeView.swift
│   │   ├── Journal/
│   │   │   ├── DreamJournalView.swift
│   │   │   ├── DreamDetailView.swift
│   │   │   └── AddDreamView.swift
│   │   ├── Sleep/
│   │   │   └── SleepTrackerView.swift
│   │   ├── Analysis/
│   │   │   └── DreamAnalysisView.swift
│   │   ├── Settings/
│   │   │   ├── SettingsView.swift
│   │   │   └── PremiumView.swift
│   │   └── Components/
│   │       ├── DreamCard.swift
│   │       ├── MoodRing.swift
│   │       ├── SleepChart.swift
│   │       ├── AudioWaveform.swift
│   │       ├── AIAnalysisCard.swift
│   │       └── PremiumBadge.swift
│   ├── Services/
│   │   ├── DatabaseService.swift
│   │   ├── AnalysisService.swift
│   │   └── SubscriptionService.swift
│   ├── Theme/
│   │   ├── Colors.swift
│   │   └── Typography.swift
│   ├── Extensions/
│   │   └── Date+Extensions.swift
│   └── Resources/
│       └── Assets.xcassets/
├── project.yml
├── Podfile (if needed)
├── Info.plist
└── DreamoraAiProTests/
    └── DreamoraAiProTests.swift
```

---

## 7. Privacy & Compliance

- All data stored locally on device
- No analytics or tracking without consent
- Privacy Policy URL required for App Store (use placeholder: https://dreamora.app/privacy)
- HealthKit: optional, with clear permission prompt
- No user accounts required (guest mode fine)

---

## 8. Build Configuration

- **Development Team:** ZhiFeng Sun (9L6N2ZF26B)
- **Code Signing:** Automatic
- **Deployment Target:** iOS 17.0
- **Devices:** iPhone only (iPad support optional)
- **Orientations:** Portrait only