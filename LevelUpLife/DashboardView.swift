import SwiftUI

struct DashboardView: View {
    @State private var userName = "Rohan"
    @State private var ultimateGoal = "To Become a software engineer."
    @State private var ultimateGoalLevelReached = 7 // Example level
    @State private var ultimateGoalProgress: Double = 0.7 // 70% progress towards ultimate goal
    @State private var lessonsCompletedStreak = 5
    @State private var dailyCheckInsStreak = 10
    @State private var dailyCheckInCompleted = true
    @State private var longestStreak = 15 // Example value for longest streak
    @State private var showingCheckInSheet = false // New state for sheet presentation
    @State private var selectedMood: String = "Happy" // Re-introducing selectedMood
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                                .clipShape(Circle())
                                .padding(.trailing, 5)
                            
                            Text("Hi \(userName)!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Button(action: {
                                // Action for list.dash image
                            }) {
                                Image(systemName: "list.dash")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text(" ")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Ultimate Goal Section
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading) {
                            Text("Future Milestone")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text(ultimateGoal)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                    Text("Level Achieved: \(ultimateGoalLevelReached)")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                ZStack {
                                    Circle()
                                        .stroke(lineWidth: 5)
                                        .opacity(0.3)
                                        .foregroundColor(.white)
                                    
                                    Circle()
                                        .trim(from: 0.0, to: CGFloat(ultimateGoalProgress))
                                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(.white)
                                        .rotationEffect(Angle(degrees: 270.0))
                                    
                                    Text("\(Int(ultimateGoalProgress * 100))%")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 60, height: 60)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 0.4, green: 0.6, blue: 1.0), Color(red: 0.6, green: 0.4, blue: 1.0)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5) // Added shadow for attractiveness
                    }
                    .padding(.horizontal)
                    
                    // Mood History Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Mood History")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<7) { index in
                                    let moodData = getMoodData(for: index)
                                    MoodEntryView(day: Calendar.current.shortWeekdaySymbols[index], moodEmoji: moodData.emoji, bgColor: moodData.color)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Current Streak Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Your current streak")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Image(systemName: "trophy.fill")
                                .font(.title2)
                                .foregroundColor(.yellow)
                            Text("\(longestStreak)") // Display the longest streak number
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                        }
                        Text("These are the number of days completed for each item")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        StreakCard(imageName: "book.closed.fill", description: "Lessons Completed", days: lessonsCompletedStreak, color: Color(red: 0.8, green: 0.95, blue: 0.8))
                        StreakCard(imageName: "calendar.badge.checkmark", description: "Daily Check-Ins", days: dailyCheckInsStreak, color: Color(red: 0.8, green: 0.95, blue: 0.8))
                    }
                    .padding(.horizontal)
                    
                    // What's our task today?
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What's our task today?")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 15) {
                            TaskCard(title: "Daily Check-Ins", description: "Doing these daily helps build a routine of self-care", isCompleted: dailyCheckInCompleted)
                            TaskCard(title: "Finish Lesson", description: "Dieting leads to weight gain", isCompleted: false)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) { // Floating action button
                Button(action: {
                    showingCheckInSheet = true
                }) {
                    Label("Check-in", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingCheckInSheet) {
            CheckInView(dailyCheckInCompleted: $dailyCheckInCompleted,
                        lessonsCompletedStreak: $lessonsCompletedStreak,
                        dailyCheckInsStreak: $dailyCheckInsStreak,
                        selectedMood: $selectedMood)
        }
    }
}

struct StreakCard: View {
    let imageName: String
    let description: String
    let days: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
               // .foregroundColor(Color.green.opacity(0.8))
                .padding(8)
                .background(Color.green.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(description)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text("\(days) days")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(color)
        .cornerRadius(10)
    }
}

struct TaskCard: View {
    let title: String
    let description: String
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if isCompleted {
                HStack(spacing: 5) {
                    Text("Completed")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            } else {
                Button(action: {
                    // Action to complete task
                }) {
                    Text("Complete")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                }
            }
        }
        .padding()
        .frame(width: 170, height: 180) // Adjust size as needed
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

func getMoodData(for dayIndex: Int) -> (emoji: String, color: Color) {
    let moodEmojis = ["😡", "😔", "😐", "😟", "😊", "😄", "🥳"]
    let moodColors = [
        Color(red: 1.0, green: 0.7, blue: 0.7), // Red-ish for stressed
        Color(red: 0.7, green: 0.9, blue: 1.0), // Light blue-ish for sad
        Color(red: 0.8, green: 0.9, blue: 0.8), // Light green-ish for neutral
        Color(red: 1.0, green: 0.8, blue: 0.9), // Pink-ish for worried
        Color(red: 0.8, green: 1.0, blue: 0.8), // Green-ish for happy
        Color(red: 1.0, green: 0.9, blue: 0.7), // Light orange for excited
        Color(red: 0.9, green: 0.8, blue: 1.0)  // Purple-ish for energetic
    ]
    
    let emoji = moodEmojis[dayIndex % moodEmojis.count]
    let color = moodColors[dayIndex % moodColors.count]
    return (emoji, color)
}

struct MoodEntryView: View {
    let day: String
    let moodEmoji: String
    let bgColor: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(moodEmoji)
                .font(.system(size: 30))
            Text(day)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 55, height: 75)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    Group {
        DashboardView()
            .previewDisplayName("Light Mode")
    }
}
