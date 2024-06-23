//
//  ToastView.swift
//  Glossika-Assignment
//
//  Created by Bomi Chen on 2024/6/19.
//

import SwiftUI

enum ToastViewType {
    case success
    case warning
    case error
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return Color.green.opacity(0.9)
        case .warning:
            return Color.yellow.opacity(0.95)
        case .error:
            return Color.red.opacity(0.95)
        }
    }
    
    var icon: String {
        switch self {
        case .success:
            return "checkmark.circle"
        case .warning:
            return "exclamationmark.triangle"
        case .error:
            return "xmark.circle.fill"
        }
    }
}

struct ToastView: View {
    
    @State private var showToast: Bool = false
    
    let type: ToastViewType
    let message: String?
    
    init(type: ToastViewType = .warning, message: String? = nil) {
        self.type = type
        self.message = message
    }
    
    var body: some View {
        ZStack {
            HStack {
                if let message = message, !message.isEmpty {
                    Image(systemName: type.icon)
                        .foregroundColor(.white)
                        .padding(.leading, 4)
                    Text(message)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                } else {
                    Image(systemName: type.icon)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(type.backgroundColor)
            .cornerRadius(10)
        }
        .allowsHitTesting(false)
    }
}

struct PreviewView: View {
    var body: some View {
        VStack {
            ToastView(type: .success, message: "This is a Success")
            ToastView(type: .warning, message: "This is a warning")
            ToastView(type: .error, message: "This is a Error")
            ToastView(type: .error)
            ToastView(type: .warning, message: "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            PreviewView()
        }
        .previewLayout(.device)
    }
}
