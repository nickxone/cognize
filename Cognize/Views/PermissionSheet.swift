//
//  PermissionSheet.swift
//  Cognize
//
//  Created by Matvii Ustich on 30/07/2025.
//

import FamilyControls
import SwiftUI

/// Permissions required by the app
enum Permission: String, CaseIterable {
    case notifications = "Notifications"
    case familyControls = "Family Controls"

    var symbol: String {
        switch self {
        case .notifications: "message.badge.filled.fill"
        case .familyControls: "figure.and.child.holdinghands"
        }
    }

    var orderedIndex: Int {
        switch self {
        case .notifications: 0
        case .familyControls: 1
        }
    }

    func isGranted() async -> Bool? {
        var result: Bool?

        switch self {
        case .notifications:
            let settings = await UNUserNotificationCenter.current()
                .notificationSettings()
            switch settings.authorizationStatus {
            case .notDetermined:
                result = nil
            case .authorized, .provisional, .ephemeral:
                result = true
            default:
                result = false
            }
        case .familyControls:
            let status = AuthorizationCenter.shared.authorizationStatus
            result =
                status == .notDetermined
                ? nil : (status == .denied ? false : true)

        }
        return result

    }

}

extension View {
    @ViewBuilder
    func permissionSheet(_ permissions: [Permission]) -> some View {
        self
            .modifier(PermissionSheetViewModifier(permissions: permissions))
    }
}

private struct PermissionSheetViewModifier: ViewModifier {
    init(permissions: [Permission]) {
        self._permissions = .init(initialValue: permissions)
    }

    @State private var permissions: [Permission] = []
    @State private var showSheet: Bool = false
    @State private var states: [PermissionState] = []
    @State private var currentIndex: Int = 0

    @Environment(\.openURL) var openURL

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 20) {
                    Text("Required Permissions")
                        .font(.title)
                        .fontWeight(.bold)

                    Image(
                        systemName: isAllGranted
                            ? "person.badge.shield.checkmark"
                            : "person.badge.shield.exclamationmark"
                    )
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(width: 100, height: 100)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.blue.gradient)
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(states) { state in
                            PermissionRow(state)
                                .contentShape(.rect)
                                .onTapGesture {
                                    requestPermission(state.id.orderedIndex)
                                }
                        }
                    }
                    .padding(.top, 10)

                    Spacer(minLength: 0)

                    Button {
                        showSheet = false
                    } label: {
                        Text("Start using the App")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(.blue.gradient, in: .capsule)
                    }
                    .disabled(!isAllGranted)
                    .opacity(isAllGranted ? 1 : 0.6)
                    .overlay(alignment: .top) {
                        if isThereAnyRejection {
                            Button("Go To Settings") {
                                if let appSettingsURL = URL(
                                    string: UIApplication.openSettingsURLString
                                ) {
                                    openURL(appSettingsURL)
                                }
                            }
                            .offset(y: -30)
                        }
                    }

                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .presentationDetents([.height(480)])
                .interactiveDismissDisabled()

            }
            .onChange(of: AuthorizationCenter.shared.authorizationStatus) {
                oldValue,
                status in
                if let index = states.firstIndex(where: {
                    $0.id == .familyControls
                }) {
                    if status == .notDetermined {
                        requestPermission(index)
                    }
                    states[index].isGranted =
                        status == .notDetermined
                        ? nil : (status == .denied ? false : true)
                }
            }
            .onChange(of: currentIndex) { oldValue, newValue in
                guard states[newValue].isGranted == nil else { return }
                requestPermission(newValue)
            }
            .onAppear {
                Task {
                    let initialState = permissions.sorted(by: {
                        $0.orderedIndex < $1.orderedIndex
                    })
                    var permissionStates: [PermissionState] = []
                    
                    for permission in initialState {
                        permissionStates.append(await PermissionState(id: permission))
                    }
                    
                    states = permissionStates
                    
                    showSheet = !isAllGranted
                    if let firstRequestPermission = states.firstIndex(where: {
                        $0.isGranted == nil
                    }) {
                        currentIndex = firstRequestPermission
                        requestPermission(firstRequestPermission)
                    }
                }
            }
    }

    @ViewBuilder
    private func PermissionRow(_ state: PermissionState) -> some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(.gray, lineWidth: 1)

                Group {
                    if let isGranted = state.isGranted {
                        Image(
                            systemName: isGranted
                                ? "checkmark.circle.fill" : "xmark.circle.fill"
                        )
                        .foregroundStyle(isGranted ? .green : .red)
                    } else {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundStyle(.gray)
                    }
                }
                .font(.title3)
                .transition(.symbolEffect)
            }
            .frame(width: 22, height: 22)

            Text(state.id.rawValue)
        }
        .lineLimit(1)
    }

    private func requestPermission(_ index: Int) {
        Task { @MainActor in
            let permission = states[index].id

            switch permission {
            case .notifications:
                let status = try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge])
                states[index].isGranted = status
            case .familyControls:
                let center = AuthorizationCenter.shared
                try await center.requestAuthorization(for: .individual)
            }

            currentIndex = min(currentIndex + 1, states.count - 1)
        }
    }

    private var isAllGranted: Bool {
        states.filter({
            if let isGranted = $0.isGranted {
                return isGranted
            }
            return false
        }).count == states.count
    }

    private var isThereAnyRejection: Bool {
        states.contains(where: { $0.isGranted == false })
    }

    private struct PermissionState: Identifiable {
        var id: Permission
        var isGranted: Bool?

        init(id: Permission) async {
            self.id = id
            self.isGranted = await id.isGranted()
        }

    }
}

#Preview {
    //    PermissionSheet()
}
