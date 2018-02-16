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
        self.quizzes[1].questionAnswers = []
        self.quizzes[2].questionAnswers = []
        quizzes[0].questionAnswers.append(QuestionAnswer(question: "5 x 4", answers: ["10", "5", "9", "20"], correctAnswer: 4))
        quizzes[0].questionAnswers.append(QuestionAnswer(question: "4 x 6", answers: ["24", "10", "2", "-2"], correctAnswer: 1))
        quizzes[0].questionAnswers.append(QuestionAnswer(question: "3 to the power of 2", answers: ["5", "6", "9", "3"], correctAnswer: 3))
        quizzes[0].questionAnswers.append(QuestionAnswer(question: "5!", answers: ["20", "120", "10", "5"], correctAnswer: 2))
        quizzes[1].questionAnswers.append(QuestionAnswer(question: "When was\nIron-Man released?", answers: ["2008", "2010", "2012", "2011"], correctAnswer: 1))
        quizzes[1].questionAnswers.append(QuestionAnswer(question: "What is\nThor's weapon?", answers: ["Metal Suit", "Shield", "Hammer", "Gun"], correctAnswer: 3))
        quizzes[1].questionAnswers.append(QuestionAnswer(question: "What is\nHulk's alter ego?", answers: ["Tony Stark", "Bruce Banner", "Nick Fury", "Natasha Romanov"], correctAnswer: 2))
        quizzes[1].questionAnswers.append(QuestionAnswer(question: "What city\ndoes Spiderman live in?", answers: ["Los Angeles", "San Francisco", "Seattle", "New York"], correctAnswer: 4))
        quizzes[2].questionAnswers.append(QuestionAnswer(question: "How do\nplants get energy?", answers: ["Photosynthesis", "Osmosis", "Oxygenation", "Chemistry"], correctAnswer: 1))
        quizzes[2].questionAnswers.append(QuestionAnswer(question: "What is H2O?", answers: ["Oxygen", "Chlorophyll", "Carbon", "Water"], correctAnswer: 4))
        quizzes[2].questionAnswers.append(QuestionAnswer(question: "What is\n the center of the cell?", answers: ["Mitochondria", "Nucleus", "Chloroplast", "Protoderm"], correctAnswer: 2))
    }
    
    
}
