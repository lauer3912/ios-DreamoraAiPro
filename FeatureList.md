# DreamoraAiPro — Feature List

Total: **72 features**

---

## Home Tab (15 features)

1. **Splash Animation** — Animated starfield with app logo on launch
2. **Sleep Score Ring** — Animated circular progress showing daily sleep score (0-100)
3. **Recent Dreams Card** — Horizontal scroll of 5 most recent dreams with mood color
4. **Quick Add FAB** — Floating action button to add new dream instantly
5. **Mood Ring Widget** — Real-time mood visualization ring (gradient animation)
6. **Sleep Streak Counter** — Days in a row of dream logging displayed prominently
7. **Tip of the Day** — Rotating tips related to sleep/dreaming
8. **Weekly Overview Mini Chart** — Condensed 7-day sleep trend bar chart
9. **Last Night's Dream Summary** — Shows most recent dream with AI preview
10. **Quick Stats** — Total dreams, avg mood, longest streak
11. **Notifications Bell** — Shows pending dream reminders
12. **Premium Upsell Banner** — Appears for free users on Home
13. **Sleep Quality Indicator** — Color-coded (green/yellow/red) for last night
14. **Dream Tags Cloud** — Most used tags displayed as clickable chips
15. **Settings Quick Access** — Gear icon in nav bar

---

## Dream Journal Tab (18 features)

16. **Dream List View** — All dreams in reverse chronological order
17. **Dream Card** — Shows title preview, date, mood icon, dream type badge
18. **Search Bar** — Full-text search across all dream content
19. **Filter by Mood** — Filter dreams by mood (peaceful, anxious, excited, neutral, sad)
20. **Filter by Type** — Filter by: All, Lucid, Nightmare, Recurring, Normal
21. **Sort Options** — Sort by: Date, Mood Score, Title
22. **Tag System** — Add/remove custom tags per dream (e.g., #flying, #water, #family)
23. **Date Grouping** — Dreams grouped by Today, Yesterday, This Week, Earlier
24. **Swipe Actions** — Swipe left to delete, swipe right to favorite
25. **Bulk Select** — Multi-select for batch delete/export
26. **Empty State** — Illustrated empty state encouraging first dream entry
27. **Dream Detail View** — Full dream text, audio player, AI analysis sections
28. **Audio Playback** — Play attached voice recording with waveform visualization
29. **Mood Selection** — 5 mood options with emoji icons
30. **Dream Type Badge** — Badge showing dream classification
31. **Edit Dream** — Edit dream text after saving
32. **Share Dream** — Share as text or image card
33. **Favorite Dream** — Star/unstar dreams for quick access

---

## Add Dream Flow (12 features)

34. **Add Dream Screen** — Full-screen modal for new dream entry
35. **Text Input** — Multi-line text field with placeholder "Describe your dream..."
36. **Voice Recording** — Record button with animated waveform, tap to stop
37. **Speech-to-Text** — Automatic transcription of voice recording
38. **Date/Time Picker** — Auto-fills with current time, allows edit
39. **Mood Picker** — 5 mood options in horizontal scroll selector
40. **Dream Type Selector** — 4 options: Normal, Lucid, Nightmare, Recurring
41. **Tag Input** — Add custom tags with autocomplete from existing tags
42. **Save Button** — Prominent save with haptic feedback
43. **Discard Confirmation** — Alert if user tries to leave without saving
44. **Character Counter** — Shows character count for dream text
45. **Preview Mode** — See how dream will look before saving

---

## AI Dream Analysis (14 features)

46. **AI Analysis Card** — Expandable card with shimmer loading state
47. **Emotion Breakdown** — Pie chart: calm (40%), anxiety (25%), excitement (35%)
48. **Top Symbols** — List of detected symbols (e.g., water=transformation, falling=fear)
49. **Theme Tags** — Auto-generated tags: #self-discovery, #stress, #creativity
50. **Recurring Patterns** — Notice if dream theme repeats across dates
51. **Psychology Insight** — Short text based on Jungian/Freudian interpretation
52. **Similar Dreams** — Show 3 most similar past dreams by content
53. **Sleep Correlation** — Link dream content to sleep quality that night
54. **Word Cloud** — Visual word frequency map of dream content
55. **Sentiment Timeline** — Line graph of mood across recent dreams
56. **Symbol Dictionary Lookup** — Tap any symbol for detailed meaning
57. **AI Confidence Score** — Shows how confident the analysis is
58. **Rephrase Dream** — AI rephrases dream in more articulate language
59. **Share Analysis** — Export analysis as shareable card

---

## Sleep Tracker Tab (10 features)

60. **Weekly Bar Chart** — 7 bars showing sleep score per night
61. **Average Sleep Score** — Large number display of weekly average
62. **Best/Worst Night** — Highlight which days had highest/lowest scores
63. **Sleep Tips** — Personalized tips based on trend
64. **HealthKit Integration** — Optional read of Apple Health sleep data
65. **Manual Sleep Log** — Manually log sleep/wake time
66. **Trend Arrow** — Up/down arrow showing trend vs previous week
67. **Sleep Goal Setting** — Set target sleep score
68. **Calendar Heat Map** — Monthly calendar with color-coded sleep scores
69. **Insights Carousel** — Swipeable cards with 3-5 key insights

---

## Settings Tab (14 features)

70. **Account Section** — Placeholder for future account system
71. **Subscription Status** — Shows Free/Premium with upgrade button
72. **Notification Preferences** — Toggle: Morning reminder, Weekly report, Motivational tips
73. **Theme Selector** — Dark (default) / Light toggle (light mode secondary)
74. **Privacy Policy Link** — Opens privacy policy URL
75. **Terms of Service Link** — Opens ToS URL
76. **Export All Data** — Export all dreams as JSON or PDF
77. **Delete All Data** — Full wipe with confirmation
78. **App Version Display** — Current version number
79. **Rate App Link** — Opens App Store rating prompt
80. **Contact Support** — Email link for support
81. **Share App** — Share App Store link
82. **About/Credits** — Attribution and credits screen
83. **Reset Onboarding** — Re-show onboarding flow

---

## Premium / Subscription (8 features)

84. **Premium Upsell Screen** — Feature comparison table
85. **Monthly Plan** — $4.99/month
86. **Yearly Plan** — $39.99/year (33% savings)
87. **3-Day Free Trial** — Trial badge on monthly plan
88. **Unlock Animation** — Celebration animation when upgrading
89. **Premium Badge** — Glowing badge on premium-only features
90. **Restore Purchases** — Button to restore if reinstalled
91. **Subscription Management** — Link to Apple subscription settings

---

## Onboarding (4 features)

92. **Welcome Screen** — Animated intro explaining app value
93. **Permission Request** — Notifications permission prompt
94. **First Dream Tutorial** — Guided flow to record first dream
95. **Premium Trial Prompt** — Offer 3-day trial after onboarding

---

## System / Technical (10 features)

96. **Offline-First** — All features work without internet
97. **Haptic Feedback** — Critical actions have haptic confirmation
98. **Dark Mode Only** — Primary UI is dark theme (light secondary)
99. **Local SQLite DB** — All data persisted locally
100. **iOS 17+ Optimized** — Uses latest SwiftUI features
101. **iPhone Portrait Only** — No iPad/landscape support
102. **Accessibility Support** — VoiceOver labels on all interactive elements
103. **Dynamic Type** — Respects user's text size preference
104. **Memory Efficient** — Lazy loading for dream list
105. **Launch Performance** — Splash to interactive < 1 second

---

## Feature Priority Summary

| Priority | Count | Features |
|----------|-------|----------|
| P0 (Must) | 15 | Home score, journal CRUD, add dream, AI analysis mock, dark theme |
| P1 (Important) | 25 | Search, filters, tags, sleep chart, notifications, stats |
| P2 (Nice) | 60 | Audio recording, HealthKit, export, premium features, onboarding |
| **Total** | **100** | — |