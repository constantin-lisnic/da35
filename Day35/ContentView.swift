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

struct Question: View {
    let text: String
    let answer: Int

    var body: some View {
        Text(text)
    }
}

struct Practice: View {
    @Binding var currentQuestion: Int
    @Binding var pack: [Question]
    

    var body: some View {
        VStack {
            pack[currentQuestion]
            Text("=")
        }
    }
}

struct ContentView: View {
    @State private var multiplicationUpTo = 2
    @State private var selectedPack = 5
    @State private var isPracticing = false
    @State private var currentQuestion: Int = 0

    @State private var pack = [Question]()

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
                    Practice(currentQuestion: $currentQuestion, pack: $pack)
                }

                Spacer()

                Button("End practice") {
                    isPracticing = false
                }
            }
            .navigationTitle("Practice multiplication")
        }
    }

    func generateQuestionPack() {
        pack = (0..<selectedPack).map { _ in
            let random1 = Int.random(in: 2...multiplicationUpTo)
            let random2 = Int.random(in: 2...multiplicationUpTo)
            return Question(
                text: "\(random1) x \(random2)", answer: random1 * random2)
        }
    }

}

#Preview {
    ContentView()
}
