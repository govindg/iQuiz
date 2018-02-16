//
//  QuizRepository.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/10/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import Foundation

class Quiz {
    init(name: String, description: String, image: String, questionAnswers: [QuestionAnswer]) {
        self.name = name
        self.description = description
        self.image = image
        self.questionAnswers = questionAnswers
    }
    var name = ""
    var description = ""
    var image = ""
    var questionAnswers : [QuestionAnswer] = []
}

class QuestionAnswer {
    init(question: String, answers: [String], correctAnswer: Int) {
        self.question = question
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
    var question = ""
    var answers : [String] = []
    var correctAnswer : Int = -1
}

class QuizRepository {
    static let shared = QuizRepository()
    
    private var quizzes : [Quiz] = [
        Quiz(name: "Mathematics", description: "Questions about Mathematics.", image: "mathematics.png", questionAnswers: []),
        Quiz(name: "Marvel Super Heroes", description: "Questions about Marvel Super Heroes.", image: "marvel_super_hero.png", questionAnswers: []),
        Quiz(name: "Science", description: "Questions about various scientific subjects.", image: "science.png", questionAnswers: [])
    ]
    
    func getQuizzes() -> [Quiz] {
        populateQuestions()
        return quizzes
    }
    func getQuiz(id: Int) -> Quiz {
        return quizzes[id]
    }
    func update(quiz: Quiz) {
        quizzes.append(quiz)
    }
    func populateQuestions() {
        self.quizzes[0].questionAnswers = []
        quizzes[0].questionAnswers.append(QuestionAnswer(question: "5 x 4", answers: ["10", "5", "9", "20"], correctAnswer: 4))
        quizzes[0].questionAnswers.append(QuestionAnswer(question: "4 x 6", answers: ["24", "10", "2", "-2"], correctAnswer: 1))
    }
    
    
}
