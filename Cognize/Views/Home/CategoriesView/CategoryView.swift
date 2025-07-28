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
            VStack {
                Text("\(category.name)")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .padding()
                
                CategoryReportView(category: category)
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: UIScreen.main.bounds.height * 0.4)
            .background(.thinMaterial)
            .cornerRadius(10)
            .shadow(radius: 4)
            
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    //    CategoryView()
}
