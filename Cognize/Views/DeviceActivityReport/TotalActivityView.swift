//
//  TotalActivityView.swift
//  Cognize
//
//  Created by Matvii Ustich on 22/07/2025.
//

import SwiftUI

struct TotalActivityView: View {
    let totalActivity: String
    
    var body: some View {
        Text(totalActivity)
    }
}

#Preview {
    TotalActivityView(totalActivity: "String")
}
