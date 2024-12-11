//
//  ContentView.swift
//  quickNote
//
//  Created by Manish Sri Sai Surya Routhu on 12/11/24.
//

import SwiftUI

struct MeditationApp: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MeditationView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Meditation")
                }
                .tag(0)

            ArticlesView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Articles")
                }
                .tag(1)

            GurusView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Gurus")
                }
                .tag(2)
        }
    }
}

// Meditation Tab
struct MeditationView: View {
    @State private var selectedDuration = 10
    @State private var timeRemaining = 10
    @State private var timer: Timer? = nil
    @State private var isMeditating = false

    let durations = [5, 10, 15, 20]

    var body: some View {
        VStack(spacing: 20) {
            Text("Meditation Timer")
                .font(.largeTitle)
                .bold()

            Picker("Duration", selection: $selectedDuration) {
                ForEach(durations, id: \ .self) { duration in
                    Text("\(duration) minutes")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedDuration) { newValue in
                timeRemaining = newValue * 60
            }

            Text("Time Remaining: \(timeFormatted())")
                .font(.title2)

            HStack {
                Button(action: startMeditation) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isMeditating)

                Button(action: pauseMeditation) {
                    Text("Pause")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isMeditating)
            }
        }
        .padding()
    }

    func startMeditation() {
        if timer == nil {
            timeRemaining = selectedDuration * 60
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    pauseMeditation()
                }
            }
            isMeditating = true
        }
    }

    func pauseMeditation() {
        timer?.invalidate()
        timer = nil
        isMeditating = false
    }

    func timeFormatted() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// Articles Tab
struct ArticlesView: View {
    let articles: [Article] = [
        Article(title: "Introduction to Kriya Yoga", description: "Learn the basics of Kriya Yoga and its benefits.", imageUrl: "book"),
        Article(title: "Breathing Techniques", description: "Master key breathing techniques in Kriya Yoga.", imageUrl: "wind")
    ]

    var body: some View {
        NavigationView {
            List(articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    ArticleCard(article: article)
                }
            }
            .navigationTitle("Articles")
        }
    }
}

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: article.imageUrl)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Text(article.title)
                .font(.title)
                .bold()

            Text(article.description)
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Article Details")
    }
}

struct ArticleCard: View {
    let article: Article

    var body: some View {
        HStack {
            Image(systemName: article.imageUrl)
                .resizable()
                .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline)

                Text(article.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageUrl: String
}

// Gurus Tab
struct GurusView: View {
    let gurus: [Guru] = [
        Guru(name: "Paramahansa Yogananda", description: "Author of 'Autobiography of a Yogi'.", imageUrl: "person.crop.circle"),
        Guru(name: "Sri Yukteswar", description: "The revered guru of Yogananda.", imageUrl: "person.circle")
    ]

    var body: some View {
        NavigationView {
            List(gurus) { guru in
                GuruCard(guru: guru)
            }
            .navigationTitle("Gurus")
        }
    }
}

struct GuruCard: View {
    let guru: Guru

    var body: some View {
        HStack {
            Image(systemName: guru.imageUrl)
                .resizable()
                .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                Text(guru.name)
                    .font(.headline)

                Text(guru.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Guru: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let imageUrl: String
}

@main
struct MeditationAppMain: App {
    var body: some Scene {
        WindowGroup {
            MeditationApp()
        }
    }
}

