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
            
            CategoriesReportView()
        }
        .padding()
    }
}

#Preview {
    CategoriesOverview()
}
