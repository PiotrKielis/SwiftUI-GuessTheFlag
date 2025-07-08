import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .shadow(radius: 5)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var attempt: Int = 0
    @State private var gameOver: Bool = false
    
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .clipShape(.buttonBorder)
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Text("Guess the flag")
                    .titleStyle()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.white)
                            .font(.headline)
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .padding()
                Text("Score \(score)")
                    .foregroundStyle(.white)
                    .font(.subheadline.bold())
                    .shadow(radius: 5)
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(scoreTitle, isPresented: $gameOver) {
            Button("Start new game", action: gameReset)
        } message: {
            Text("You ran out of attempts")
        }
    }
    func gameReset() {
        score = 0
        attempt = 0
        gameOver = false
        askQuestion()
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        attempt += 1
        if attempt == 10 {
            scoreTitle = "Game Over"
            gameOver = true
        } else {
            showingScore = true
        }
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
