//
//  CategoryView.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI

struct CategoryView: View {
    let category: Category
    
    var body: some View {
        VStack {
            Text("\(category.name)")
            
            CategoryReportView(category: category)
        }
        .padding()
    }
}

#Preview {
//    CategoryView()
}
