import SwiftUI

struct CheckInView: View {
    @Binding var dailyCheckInCompleted: Bool
    @Binding var lessonsCompletedStreak: Int
    @Binding var dailyCheckInsStreak: Int
    @Binding var selectedMood: String // Assuming you'll re-add mood to dashboard, or it will be updated here
    
    @Environment(\.dismiss) var dismiss
    
    let moods = ["Happy", "Good", "Neutral", "Tired", "Stressed"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Daily Check-in")) {
                    Toggle("Mark Daily Check-in as Complete", isOn: $dailyCheckInCompleted)
                }
                
                Section(header: Text("Lessons Progress")) {
                    Stepper("Lessons Completed: \(lessonsCompletedStreak)", value: $lessonsCompletedStreak, in: 0...1000)
                }
                
                Section(header: Text("How are you feeling today?")) {
                    Picker("Mood", selection: $selectedMood) {
                        ForEach(moods, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: .constant("Add your notes here...")) // Placeholder for now
                        .frame(height: 100)
                }
            }
            .navigationTitle("Daily Check-in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Logic to update dashboard will happen via bindings
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    CheckInView(dailyCheckInCompleted: .constant(false),
                lessonsCompletedStreak: .constant(5),
                dailyCheckInsStreak: .constant(10),
                selectedMood: .constant("Happy"))
} 