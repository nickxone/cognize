//
//  SettingsView.swift
//  Cognize
//
//  Created by Matvii Ustich on 20/07/2025.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        Button {
            print("I don't do anything yet...")
        } label: {
            Text("Clear All Settings")
        }
    }
}

struct CardItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
}

struct AppStoreExpandableDemo: View {
    @Namespace private var namespace
    
    @State private var selectedItem: CardItem? = nil
    @State private var showDetail = false
    
    let items = [
        CardItem(title: "SwiftUI Mastery", subtitle: "Learn Animation", color: .blue),
        CardItem(title: "Daily Focus", subtitle: "Productivity", color: .purple),
        CardItem(title: "Night Sky", subtitle: "Astronomy", color: .black),
        CardItem(title: "Healthy Eating", subtitle: "Recipes", color: .green)
    ]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Today")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 40)
                    
                    ForEach(items) { item in
                        CardView(item: item)
                            .matchedGeometryEffect(id: item.id, in: namespace)
                            .frame(height: 350)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedItem = item
                                    showDetail = true
                                }
                            }
                    }
                }
                .padding()
            }
            
            // LAYER 2: The Full Screen Overlay
            if let selectedItem = selectedItem, showDetail {
                DetailView(item: selectedItem)
                    .matchedGeometryEffect(id: selectedItem.id, in: namespace)
                    .ignoresSafeArea()
                // Add a background to cover the list behind it
                    .background(Color(.systemBackground))
                    .transition(.identity) // Prevents default fade-in/out
            }
        }
    }
    
    // MARK: - Subviews
    
    // The Small Card
    func CardView(item: CardItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.subtitle.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.7))
            
            Text(item.title)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(item.color.gradient)
        )
    }
    
    // The Expanded Detail View
    func DetailView(item: CardItem) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header (Matches the Card Look)
                VStack(alignment: .leading, spacing: 12) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                showDetail = false
                                selectedItem = nil
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.body.weight(.bold))
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                    
                    Text(item.subtitle.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text(item.title)
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(20)
                .padding(.top, 40) // Status bar spacing
                .frame(height: 350) // Match card height or make taller
                .background(
                    RoundedRectangle(cornerRadius: 0, style: .continuous) // Corner radius becomes 0
                        .fill(item.color.gradient)
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("About this Collection")
                        .font(.title2.bold())
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    
                    Text("Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(20)
                .opacity(showDetail ? 1 : 0)
            }
        }
    }
}

#Preview {
    AppStoreExpandableDemo()
}
