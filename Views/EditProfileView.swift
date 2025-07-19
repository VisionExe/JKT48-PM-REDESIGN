//
//  EditProfileView.swift
//  AtomicApplication
//
//  Created by Hillary Abigail on 18/07/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    let user: User?
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var bio: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?
    
    @State private var showingDatePicker = false
    @State private var showingSaveAlert = false
    @State private var animateForm = false
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Photo Section
                    profilePhotoSection
                    
                    // Form Fields
                    formSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                .opacity(animateForm ? 1.0 : 0.0)
                .offset(y: animateForm ? 0 : 20)
            }
            .background(JKT48Colors.groupedBackground)
            .navigationTitle("Edit Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        dismiss()
                    }
                    .foregroundColor(JKT48Colors.primaryPink)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Simpan") {
                        saveProfile()
                    }
                    .foregroundColor(JKT48Colors.primaryPink)
                    .fontWeight(.semibold)
                    .disabled(name.isEmpty || email.isEmpty || isSaving)
                }
            }
        }
        .onAppear {
            loadUserData()
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateForm = true
            }
        }
        .onChange(of: selectedPhoto) { _, newPhoto in
            Task {
                if let newPhoto = newPhoto {
                    if let data = try? await newPhoto.loadTransferable(type: Data.self) {
                        profileImage = UIImage(data: data)
                    }
                }
            }
        }
        .alert("Profil Tersimpan", isPresented: $showingSaveAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Profil Anda berhasil diperbarui.")
        }
    }
    
    private var profilePhotoSection: some View {
        VStack(spacing: 16) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                ZStack {
                    Circle()
                        .fill(JKT48Colors.lightPinkGradient)
                        .frame(width: 120, height: 120)
                    
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else if let imageData = user?.profileImageData,
                              let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("Tambah Foto")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Edit overlay
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 120, height: 120)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(JKT48Colors.primaryPink)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "pencil")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: -8, y: -8)
                        }
                    }
                }
            }
            
            Text("Tap untuk mengganti foto")
                .font(.caption)
                .foregroundColor(JKT48Colors.secondaryLabel)
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            JKT48TextField(
                title: "Nama Lengkap",
                text: $name,
                icon: "person.fill"
            )
            
            JKT48TextField(
                title: "Email",
                text: $email,
                icon: "envelope.fill",
                keyboardType: .emailAddress
            )
            
            JKT48TextField(
                title: "Nomor Telepon",
                text: $phoneNumber,
                icon: "phone.fill",
                keyboardType: .phonePad
            )
            
            // Date of Birth
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(JKT48Colors.primaryPink)
                    Text("Tanggal Lahir")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    Spacer()
                }
                
                Button(action: { showingDatePicker = true }) {
                    HStack {
                        Text(formatDate(dateOfBirth))
                            .foregroundColor(JKT48Colors.primaryLabel)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(JKT48Colors.secondaryLabel)
                            .font(.caption)
                    }
                    .padding(16)
                    .background(JKT48Colors.cardBackground(for: colorScheme))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Bio
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "text.alignleft")
                        .foregroundColor(JKT48Colors.primaryPink)
                    Text("Bio")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(JKT48Colors.primaryLabel)
                    Spacer()
                }
                
                TextEditor(text: $bio)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(JKT48Colors.cardBackground(for: colorScheme))
                    .cornerRadius(12)
                    .font(.body)
                    .foregroundColor(JKT48Colors.primaryLabel)
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            NavigationStack {
                VStack {
                    DatePicker(
                        "Tanggal Lahir",
                        selection: $dateOfBirth,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.wheel)
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("Tanggal Lahir")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Selesai") {
                            showingDatePicker = false
                        }
                        .foregroundColor(JKT48Colors.primaryPink)
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
    
    private func loadUserData() {
        guard let user = user else { return }
        name = user.name
        email = user.email
        phoneNumber = user.phoneNumber
        bio = user.bio
        dateOfBirth = user.dateOfBirth ?? Date()
        
        if let imageData = user.profileImageData {
            profileImage = UIImage(data: imageData)
        }
    }
    
    private func saveProfile() {
        isSaving = true
        
        if let user = user {
            user.name = name
            user.email = email
            user.phoneNumber = formatPhoneNumber(phoneNumber)
            user.bio = bio
            user.dateOfBirth = dateOfBirth
            
            if let profileImage = profileImage {
                user.profileImageData = profileImage.jpegData(compressionQuality: 0.8)
            }
        } else {
            let newUser = User(
                name: name,
                email: email,
                phoneNumber: formatPhoneNumber(phoneNumber),
                bio: bio
            )
            newUser.dateOfBirth = dateOfBirth
            if let profileImage = profileImage {
                newUser.profileImageData = profileImage.jpegData(compressionQuality: 0.8)
            }
            modelContext.insert(newUser)
        }
        
        do {
            try modelContext.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isSaving = false
                showingSaveAlert = true
            }
        } catch {
            isSaving = false
            print("Error saving profile: \(error)")
        }
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let cleaned = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        if cleaned.hasPrefix("08") {
            return "+62" + String(cleaned.dropFirst())
        } else if cleaned.hasPrefix("8") {
            return "+62" + cleaned
        } else if cleaned.hasPrefix("62") {
            return "+" + cleaned
        } else {
            return phoneNumber
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
}

struct JKT48TextField: View {
    let title: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    @Environment(\.colorScheme) var colorScheme
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isFocused ? JKT48Colors.primaryPink : JKT48Colors.secondaryLabel)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isFocused ? JKT48Colors.primaryPink : JKT48Colors.primaryLabel)
                Spacer()
            }
            
            TextField("Masukkan \(title.lowercased())", text: $text)
                .font(.body)
                .padding(16)
                .background(JKT48Colors.cardBackground(for: colorScheme))
                .cornerRadius(12)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .foregroundColor(JKT48Colors.primaryLabel)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? JKT48Colors.primaryPink : Color.clear, lineWidth: 2)
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
