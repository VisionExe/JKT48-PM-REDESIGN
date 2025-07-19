//
//  PasswordResetView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI

struct PasswordResetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var animateForm = false
    @State private var isProcessing = false
    @State private var showSuccessAlert = false
    @State private var passwordStrength: PasswordStrength = .weak
    
    enum PasswordStrength {
        case weak, medium, strong
        
        var color: Color {
            switch self {
            case .weak: return .red
            case .medium: return .orange
            case .strong: return .green
            }
        }
        
        var text: String {
            switch self {
            case .weak: return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }
    }
    
    var isFormValid: Bool {
        !currentPassword.isEmpty && 
        !newPassword.isEmpty && 
        !confirmPassword.isEmpty && 
        newPassword == confirmPassword &&
        newPassword.count >= 8
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "lock.rotation")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .opacity(animateForm ? 1.0 : 0.0)
                            .scaleEffect(animateForm ? 1.0 : 0.8)
                        
                        Text("Reset Password")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Enter your current password and choose a new one")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .opacity(animateForm ? 1.0 : 0.0)
                    .offset(y: animateForm ? 0 : 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Current Password
                        SecureTextField(
                            title: "Current Password",
                            text: $currentPassword,
                            showPassword: $showCurrentPassword,
                            icon: "lock.fill"
                        )
                        
                        // New Password
                        SecureTextField(
                            title: "New Password",
                            text: $newPassword,
                            showPassword: $showNewPassword,
                            icon: "key.fill"
                        )
                        
                        // Password Strength Indicator
                        if !newPassword.isEmpty {
                            HStack {
                                Text("Password Strength:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(passwordStrength.text)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(passwordStrength.color)
                                
                                Spacer()
                            }
                        }
                        
                        // Confirm Password
                        SecureTextField(
                            title: "Confirm New Password",
                            text: $confirmPassword,
                            showPassword: $showConfirmPassword,
                            icon: "checkmark.seal.fill"
                        )
                        
                        // Password Match Indicator
                        if !confirmPassword.isEmpty {
                            HStack {
                                Image(systemName: newPassword == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(newPassword == confirmPassword ? .green : .red)
                                Text(newPassword == confirmPassword ? "Passwords match" : "Passwords don't match")
                                    .font(.caption)
                                    .foregroundColor(newPassword == confirmPassword ? .green : .red)
                                Spacer()
                            }
                        }
                        
                        // Reset Button
                        Button(action: resetPassword) {
                            HStack {
                                if isProcessing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "lock.rotation")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                Text(isProcessing ? "Resetting..." : "Reset Password")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(12)
                        }
                        .disabled(!isFormValid || isProcessing)
                        .opacity(animateForm ? 1.0 : 0.0)
                        .offset(y: animateForm ? 0 : 30)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Password Reset")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateForm = true
            }
        }
        .onChange(of: newPassword) { _, newValue in
            updatePasswordStrength(newValue)
        }
        .alert("Password Reset Successful", isPresented: $showSuccessAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your password has been successfully updated.")
        }
    }
    
    private func updatePasswordStrength(_ password: String) {
        let hasUppercase = password.contains { $0.isUppercase }
        let hasLowercase = password.contains { $0.isLowercase }
        let hasNumbers = password.contains { $0.isNumber }
        let hasSpecialChars = password.contains { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }
        
        let criteriaCount = [hasUppercase, hasLowercase, hasNumbers, hasSpecialChars].filter { $0 }.count
        
        if password.count >= 12 && criteriaCount >= 3 {
            passwordStrength = .strong
        } else if password.count >= 8 && criteriaCount >= 2 {
            passwordStrength = .medium
        } else {
            passwordStrength = .weak
        }
    }
    
    private func resetPassword() {
        isProcessing = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isProcessing = false
            showSuccessAlert = true
        }
    }
}

struct SecureTextField: View {
    let title: String
    @Binding var text: String
    @Binding var showPassword: Bool
    let icon: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isFocused ? .blue : .secondary)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isFocused ? .blue : .primary)
                Spacer()
            }
            
            HStack {
                if showPassword {
                    TextField("Enter \(title.lowercased())", text: $text)
                        .focused($isFocused)
                } else {
                    SecureField("Enter \(title.lowercased())", text: $text)
                        .focused($isFocused)
                }
                
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.secondary)
                }
            }
            .font(.body)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    PasswordResetView()
}
