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
    
    var existDuration: Double {
        switch self {
        case .success:
            return 1.5
        case .warning:
            return 3.0
        case .error:
            return 5.0
        }
    }
    
    var animationInDuration: Double {
        return 0.3
    }
    
    var animationOutDuration: Double {
        switch self {
        case .success:
            return 0.5
        case .warning, .error:
            return 0.7
        }
    }
    
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
            return "xmark.octagon"
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
            if showToast {
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
                // 入場動畫：上方+淡入, 離場動畫：淡出
                .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + type.existDuration) {
                        withAnimation(.easeOut(duration: type.animationOutDuration)) { // 離場動畫秒數
                            showToast = false
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: type.animationInDuration)) { // 入場動畫秒數
                showToast = true
            }
        }
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