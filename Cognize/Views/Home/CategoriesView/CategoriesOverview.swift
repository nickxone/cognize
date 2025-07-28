//
//  CategoriesOverview.swift
//  Cognize
//
//  Created by Matvii Ustich on 27/07/2025.
//

import SwiftUI

struct CategoriesOverview: View {
    var body: some View {
        VStack {
            Text("All Categories")
                .font(.title.bold())
                .foregroundStyle(.primary)
                .padding()
            
            CategoriesReportView()
        }
        .frame(width: UIScreen.main.bounds.width - 64)
        .background(.thinMaterial)
        .cornerRadius(10)
        .shadow(radius: 4)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CategoriesOverview()
}
