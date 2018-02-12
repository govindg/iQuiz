//
//  QuizRepository.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/10/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import Foundation

class Quiz {
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    var name = ""
    var description = ""
}

class QuizRepository {
    static let shared = QuizRepository()
    
    private var quizzes : [Quiz] = [
        Quiz(name: "Mathematics", description: "Questions about Mathematics."),
        Quiz(name: "Marvel Super Heroes", description: "Questions about Marvel Super Heroes."),
        Quiz(name: "Science", description: "Questions about various scientific subjects.")
    ]
    
    func getQuizzes() -> [Quiz] {
        return quizzes
    }
    func getQuiz(id: Int) -> Quiz {
        return quizzes[id]
    }
    func update(quiz: Quiz) {
        quizzes.append(quiz)
    }
    
    
}
