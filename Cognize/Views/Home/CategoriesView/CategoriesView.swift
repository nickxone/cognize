//
//  CategoriesView.swift
//  Cognize
//
//  Created by Matvii Ustich on 25/07/2025.
//

// MARK: DON'T load Categories lazily since the system stops rendering DeviceActivityReportExtension at some point
// as an option lazily load CardViews that will take CategoryReportView as parameters (and load CategoryReportView-s eagerly)
import SwiftUI
import FamilyControls

struct CategoriesView: View {
    @Environment(\.categoryStore) private var store
    
    @State private var categories: [Category] = []
    @State private var isCreating = false
    
    var body: some View {
        NavigationView {
            VStack {
                if categories.isEmpty {
                    Text("No Categories")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    //                    ScrollView(.horizontal, showsIndicators: false) {
                    //                        HStack(spacing: 15) {
                    //                            CategoriesOverview()
                    //
                    //                            ForEach(categories, id: \.id) { category in
                    //                                CategoryView(category: category)
                    //                            }
                    //                        }
                    //                        .scrollTargetLayout()
                    //                    }
                    //                    .scrollTargetBehavior(.viewAligned)
                    //                    .safeAreaPadding(.horizontal, 30)
                    
                    FadingCardScrollView(
                        items: categories,
                        leadingView: {
                            CategoriesOverview()
                        },
                        content: { category in
                            CategoryView(category: category)
                        }
                    )
                    
                }
                
                Spacer()
            }
            .navigationTitle("Categories")
            .toolbar {
                Button("Add") {
                    isCreating = true
                }
            }
            .sheet(isPresented: $isCreating) {
                CategoryCreationView(categories: $categories)
            }
            .onAppear {
                categories = store.load()
            }
        }
    }
}
