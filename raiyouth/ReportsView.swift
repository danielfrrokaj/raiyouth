import SwiftUI

struct ReportsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.canvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: Theme.Spacing.xxl) {
                    
                    // Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Text("All accounts")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color.theme.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("This month")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "5A8AE2")) // A subtle blue link color like in the screenshot
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.top, Theme.Spacing.xl)
                    
                    // Main Cards
                    VStack(spacing: Theme.Spacing.md) {
                        
                        // Spent Card
                        VStack(alignment: .leading, spacing: 0) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Spent")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color.theme.textSecondary)
                                Text("Make your first payment")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(Theme.Spacing.lg)
                            
                            // Mock Line Chart
                            GeometryReader { geo in
                                Path { path in
                                    let width = geo.size.width
                                    let height = geo.size.height
                                    path.move(to: CGPoint(x: 0, y: height * 0.6))
                                    path.addCurve(to: CGPoint(x: width * 0.2, y: height * 0.5), control1: CGPoint(x: width * 0.1, y: height * 0.4), control2: CGPoint(x: width * 0.15, y: height * 0.5))
                                    path.addCurve(to: CGPoint(x: width * 0.4, y: height * 0.6), control1: CGPoint(x: width * 0.25, y: height * 0.5), control2: CGPoint(x: width * 0.3, y: height * 0.6))
                                    path.addCurve(to: CGPoint(x: width * 0.6, y: height * 0.9), control1: CGPoint(x: width * 0.5, y: height * 0.6), control2: CGPoint(x: width * 0.55, y: height * 0.9))
                                    path.addCurve(to: CGPoint(x: width * 0.8, y: height * 0.4), control1: CGPoint(x: width * 0.7, y: height * 0.9), control2: CGPoint(x: width * 0.75, y: height * 0.4))
                                    path.addCurve(to: CGPoint(x: width, y: height * 0.5), control1: CGPoint(x: width * 0.9, y: height * 0.4), control2: CGPoint(x: width * 0.95, y: height * 0.7))
                                }
                                .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                                .shadow(color: Color.theme.accentPrimary.opacity(0.2), radius: 10, x: -20, y: -10)
                            }
                            .frame(height: 80)
                            .padding(.bottom, Theme.Spacing.md)
                        }
                        .background(Color.theme.surface2)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                        
                        // Income & Cashflow Grid
                        HStack(spacing: Theme.Spacing.md) {
                            
                            // Income
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Income")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color.theme.textSecondary)
                                    Text("0 ALL")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .padding(Theme.Spacing.lg)
                                
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<6) { _ in
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.white.opacity(0.05))
                                            .frame(width: 12, height: 60)
                                    }
                                }
                                .padding(.horizontal, Theme.Spacing.lg)
                                .padding(.bottom, Theme.Spacing.lg)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 180)
                            .background(Color.theme.surface2)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                            
                            // Net Cashflow
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Net cashflow")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color.theme.textSecondary)
                                    Text("0 ALL")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .padding(Theme.Spacing.lg)
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.05))
                                        .frame(height: 6)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white.opacity(0.05))
                                        .frame(height: 6)
                                }
                                .padding(.horizontal, Theme.Spacing.lg)
                                .padding(.bottom, Theme.Spacing.xl)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 180)
                            .background(Color.theme.surface2)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                        }
                        
                        // Page Indicators
                        HStack(spacing: 6) {
                            Circle().fill(Color.white.opacity(0.4)).frame(width: 5, height: 5)
                            Circle().fill(Color.white.opacity(0.4)).frame(width: 5, height: 5)
                            Circle().fill(Color.white.opacity(0.4)).frame(width: 5, height: 5)
                            Circle().fill(Color.white.opacity(0.4)).frame(width: 5, height: 5)
                        }
                        .padding(.top, 12)
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                    
                    // Overview Section
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("Overview")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, Theme.Spacing.lg)
                        
                        VStack(spacing: Theme.Spacing.md) {
                            // Total Assets
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Total assets")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color.theme.textSecondary)
                                    Text("0 ALL")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                }
                                .padding(Theme.Spacing.lg)
                                
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 6)
                                    .padding(.horizontal, Theme.Spacing.lg)
                                    .padding(.bottom, Theme.Spacing.xl)
                            }
                            .frame(height: 160)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.surface2)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                            
                            // Your Trips
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Your trips")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color.theme.textSecondary)
                                    .padding(Theme.Spacing.lg)
                                
                                Spacer()
                                
                                // Mock Map
                                ZStack {
                                    Image(systemName: "map.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.white.opacity(0.05))
                                        .frame(height: 100)
                                        .padding(.bottom, -20)
                                    
                                    Circle()
                                        .fill(Color(hex: "5A8AE2"))
                                        .frame(width: 8, height: 8)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .offset(x: 10, y: 10)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .frame(height: 160)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.theme.surface2)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous))
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    }
                    
                    Spacer().frame(height: 60)
                }
            }
        }
    }
}
