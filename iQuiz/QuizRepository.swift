//
//  QuizRepository.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/10/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import Foundation

class Quiz {
    init(name: String, description: String, image: String) {
        self.name = name
        self.description = description
        self.image = image
    }
    var name = ""
    var description = ""
    var image = ""
}

class QuizRepository {
    static let shared = QuizRepository()
    
    private var quizzes : [Quiz] = [
        Quiz(name: "Mathematics", description: "Questions about Mathematics.", image: "mathematics.png"),
        Quiz(name: "Marvel Super Heroes", description: "Questions about Marvel Super Heroes.", image: "marvel_super_hero.png"),
        Quiz(name: "Science", description: "Questions about various scientific subjects.", image: "science.png")
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
