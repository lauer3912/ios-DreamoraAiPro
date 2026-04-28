import SwiftUI

struct PremiumView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPlan: SubscriptionPlan = .yearly

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppGradient.accentDiagonal)
                                .frame(width: 80, height: 80)
                                .blur(radius: 20)
                                .opacity(0.5)

                            Image(systemName: "crown.fill")
                                .font(.system(size: 36))
                                .foregroundColor(.warning)
                        }

                        Text("Unlock Premium")
                            .font(.largeTitle.bold())
                            .foregroundColor(.textPrimary)

                        Text("Get unlimited access to all features")
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.top, 32)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        PremiumFeatureRow(icon: "infinity", title: "Unlimited Dreams", description: "Record as many dreams as you want")
                        PremiumFeatureRow(icon: "brain.head.profile", title: "AI Dream Analysis", description: "Deep psychological insights")
                        PremiumFeatureRow(icon: "waveform", title: "Audio Recording", description: "Voice memo your dreams")
                        PremiumFeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Advanced Stats", description: "Detailed sleep trends")
                        PremiumFeatureRow(icon: "square.and.arrow.up", title: "Export Dreams", description: "PDF and JSON export")
                    }
                    .padding()
                    .background(Color.surface)
                    .cornerRadius(16)

                    // Plans
                    VStack(spacing: 16) {
                        PlanCard(
                            plan: .monthly,
                            isSelected: selectedPlan == .monthly,
                            onSelect: { selectedPlan = .monthly }
                        )

                        PlanCard(
                            plan: .yearly,
                            isSelected: selectedPlan == .yearly,
                            onSelect: { selectedPlan = .yearly }
                        )
                    }

                    // Subscribe Button
                    Button(action: subscribe) {
                        Text("Subscribe — \(selectedPlan.price)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppGradient.accentDiagonal)
                            .cornerRadius(16)
                    }

                    Text("Cancel anytime. 3-day free trial included.")
                        .font(.caption)
                        .foregroundColor(.textSecondary)

                    // Restore
                    Button(action: restorePurchases) {
                        Text("Restore Purchases")
                            .font(.subheadline)
                            .foregroundColor(.accentPrimary)
                    }
                    .padding(.top, 16)
                }
                .padding()
            }
        }
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
        
    }

    func subscribe() {
        // StoreKit 2 subscription
        appState.unlockPremium()
    }

    func restorePurchases() {
        // Restore purchases
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentPrimary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.textPrimary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.success)
        }
    }
}

struct PlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.name)
                            .font(.headline)
                            .foregroundColor(.textPrimary)

                        if plan == .yearly {
                            Text("SAVE 33%")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.success)
                                .cornerRadius(4)
                        }

                        if plan == .monthly {
                            Text("3-DAY FREE TRIAL")
                                .font(.caption2.bold())
                                .foregroundColor(.accentPrimary)
                        }
                    }

                    Text(plan.description)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.price)
                        .font(.title2.bold())
                        .foregroundColor(.textPrimary)

                    Text(plan.perMonth)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .accentPrimary : .textSecondary)
            }
            .padding()
            .background(isSelected ? Color.accentPrimary.opacity(0.15) : Color.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentPrimary : Color.clear, lineWidth: 2)
            )
        }
    }
}

enum SubscriptionPlan {
    case monthly, yearly

    var name: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }

    var price: String {
        switch self {
        case .monthly: return "$4.99/mo"
        case .yearly: return "$39.99/yr"
        }
    }

    var perMonth: String {
        switch self {
        case .monthly: return ""
        case .yearly: return "$3.33/mo"
        }
    }

    var description: String {
        switch self {
        case .monthly: return "Billed monthly. Cancel anytime."
        case .yearly: return "Billed annually. Best value!"
        }
    }
}