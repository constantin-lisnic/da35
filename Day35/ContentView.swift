//
//  ContentView.swift
//  Day35
//
//  Created by Constantin Lisnic on 17/11/2024.
//

import SwiftUI

struct Settings: View {
    @Binding var multiplicationUpTo: Int
    @Binding var selectedPack: Int

    let questionPack = [5, 10, 20]

    var body: some View {
        VStack {
            Section {
                Stepper(value: $multiplicationUpTo, in: 2...12) {
                    Text("Multiplication up to \(multiplicationUpTo)")
                }
                .padding()
            }

            Section {
                HStack {
                    Text("Question amount:")
                    Picker("Question pack", selection: $selectedPack) {
                        ForEach(questionPack, id: \.self) { question in
                            Text("\(question)")
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                }.padding()
            }
        }
    }
}

struct Question {
    let text: String
    let correctAnswer: Int
    var userResponse: Int? = nil
    var isSubmitted: Bool = false
}

struct Practice: View {
    @Binding var currentQuestion: Int
    @Binding var pack: [Question]
    @Binding var score: Int

    var body: some View {
        VStack {
            Text("Question \(currentQuestion + 1)/\(pack.count)")

            Spacer()

            HStack(spacing: 50) {
                Section {
                    Button("Previous") {
                        currentQuestion -= 1
                    }
                    .disabled(currentQuestion == 0)

                    VStack {
                        Text(pack[currentQuestion].text)
                        Text("=")
                    }.font(.largeTitle)
                }

                Button("Next") {
                    currentQuestion += 1
                }
                .disabled(currentQuestion == pack.count - 1)
            }

            Spacer()

            Section {
                Text("Your answer:")
                HStack {
                    TextField(
                        "Your answer:",
                        value: $pack[currentQuestion].userResponse,
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.primary)
                    .labelsHidden()
                    .disabled(pack[currentQuestion].isSubmitted)
                    .frame(width: 250)

                    Spacer()

                    if pack[currentQuestion].isSubmitted {
                        if pack[currentQuestion].userResponse
                            == pack[currentQuestion].correctAnswer
                        {
                            Text("Correct!")
                                .foregroundStyle(.green)
                        } else {
                            Text("Wrong!")
                                .foregroundStyle(.red)
                        }
                    }
                }

                Button("Submit") {
                    submitAnswer()

                }
                .disabled(pack[currentQuestion].isSubmitted)

            }
            .padding()

            Spacer()
            Spacer()
        }
        .padding()
    }

    func submitAnswer() {
        pack[currentQuestion].isSubmitted = true
        if pack[currentQuestion].userResponse
            == pack[currentQuestion].correctAnswer
        {
            score += 1
        }
    }
}

struct ContentView: View {
    @State private var multiplicationUpTo = 2
    @State private var selectedPack = 5
    @State private var isPracticing = false
    @State private var currentQuestion: Int = 0
    @State private var score: Int = 0
    @State private var pack = [Question]()
    @State private var showFinishedAlert: Bool = false

    var hasFinishedPractice: Bool {
        if !pack.isEmpty {
            let allQuestionsSubmitted = pack.allSatisfy {
                $0.isSubmitted
            }
            return allQuestionsSubmitted
        } else {
            return false
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if !isPracticing {
                    Settings(
                        multiplicationUpTo: $multiplicationUpTo,
                        selectedPack: $selectedPack)

                    Button("Start practicing") {
                        isPracticing = true
                        generateQuestionPack()
                    }
                } else {
                    Practice(
                        currentQuestion: $currentQuestion, pack: $pack,
                        score: $score)
                }

                Spacer()

                Button("End practice") {
                    isPracticing = false
                    currentQuestion = 0
                }
            }
            .navigationTitle("Practice multiplication")
            .onChange(of: hasFinishedPractice) {
                if hasFinishedPractice {
                    showFinishedAlert = true
                }
            }
            .alert(isPresented: $showFinishedAlert) {
                Alert(
                    title: Text("Practice finished"),
                    message: Text(
                        "Your score is \(score) out of \(pack.count) questions."
                    ),
                    dismissButton: .default(Text("OK")) {
                        isPracticing = false
                        currentQuestion = 0
                    }
                )
            }
        }
    }

    func generateQuestionPack() {
        pack = (0..<selectedPack).map { _ in
            let random1 = Int.random(in: 2...multiplicationUpTo)
            let random2 = Int.random(in: 2...multiplicationUpTo)
            return Question(
                text: "\(random1) x \(random2)",
                correctAnswer: random1 * random2)
        }
    }
}

#Preview {
    ContentView()
}
