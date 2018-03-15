//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/13/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    public var questionText: String! = nil
    public var answerText: String! = nil
    public var answers: [String]! = []
    public var correctAnswer: Int = -1
    public var questionCounter = -1
    public var correctCount: Int = 0
    public var correct = false
    public var quizLength : Int = 0
    public var quiz : Quiz? = nil
    var answerPushed : Bool = false
    
    func setQuestionLabel(incoming: String) {
        self.questionText = incoming
    }
    
    func setAnswers(incomingAnswers: [String], correctAnswer: Int, counter: Int, quizLength: Int, correctCount: Int = 0) {
        self.answers = incomingAnswers
        self.correctAnswer = correctAnswer
        self.questionCounter = counter
        self.quizLength = quizLength
        self.correctCount = correctCount
    }
    
    func setQuiz(incomingQuiz: Quiz) {
        self.quiz = incomingQuiz
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.questionText != nil && self.answers != nil {
            questionLabel!.text = self.questionText
            for i in 1...answers.count {
                let tmp = self.view.viewWithTag(i) as? UIButton
                tmp!.setTitle(self.answers[i - 1], for: .normal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func answerPushed(_ sender: UIButton) {
        sender.backgroundColor = UIColor.orange
        for i in 1...answers.count {
            if sender.tag != i {
                let tmp = self.view.viewWithTag(i) as? UIButton
                tmp!.backgroundColor = UIColor.blue
            }
        }
        answerPushed = true
    }
    
    @IBAction func submitPushed(_ sender: Any) {
        if answerPushed {
            performSegue(withIdentifier: "AnswerSegue", sender: sender)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "AnswerSegue":
            let destination = segue.destination as? AnswerViewController
            for i in 1...answers.count {
                let tmp = self.view.viewWithTag(i) as? UIButton
                if tmp!.backgroundColor == UIColor.orange {
                    self.answerText = tmp!.titleLabel!.text
                    if tmp!.tag == correctAnswer {
                        correct = true
                        self.correctCount += 1
                    } else {
                        correct = false
                    }
                }
            }
            let correctAns = self.quiz!.questionAnswers[self.questionCounter - 1].answers[self.correctAnswer - 1]
            destination!.incoming(correct: self.correct, incomingQuestion: self.questionText, incomingAnswer: self.answerText, incomingcorrectCount: self.correctCount, incomingQuizLength: self.quizLength, incomingQuestionCounter: self.questionCounter, incomingQuiz: self.quiz!, incomingCorrectAnswer: correctAns)
        case "QuestionHomeSegue":
            let destination = segue.destination as? ViewController
            destination?.setLoaded(load: true)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }

}
