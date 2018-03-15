//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/14/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    public var correctCount = 0
    public var quizLength = 0
    public var answerText : String? = nil
    public var questionText : String? = nil
    public var correctText : String? = nil
    public var questionCounter = 0
    public var quiz : Quiz? = nil
    public var correctAnswer : String? = nil
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var questionAnswerLabel: UILabel!
    
    func incoming(correct: Bool, incomingQuestion: String, incomingAnswer: String, incomingcorrectCount: Int, incomingQuizLength: Int, incomingQuestionCounter: Int, incomingQuiz: Quiz, incomingCorrectAnswer: String) {
        if correct {
            self.correctText = "Correct!"
        } else {
            self.correctText = "Incorrect"
        }
        self.questionText = incomingQuestion
        self.answerText = incomingAnswer
        self.correctCount = incomingcorrectCount
        self.quizLength = incomingQuizLength
        self.questionCounter = incomingQuestionCounter
        self.quiz = incomingQuiz
        self.correctAnswer = incomingCorrectAnswer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        correctLabel.text = self.correctText
        questionAnswerLabel.text = "Your answer for \n\n \(self.questionText!) \n\n was \(self.answerText!) \n\n and the correct answer is \(self.correctAnswer!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPushed(_ sender: UIBarButtonItem) {
        if questionCounter < quizLength {
            performSegue(withIdentifier: "BackToQuestionSegue", sender: sender)
        } else {
            performSegue(withIdentifier: "FinishSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "BackToQuestionSegue":
            let destination = segue.destination as? QuestionViewController
            destination!.setQuestionLabel(incoming: self.quiz!.questionAnswers[questionCounter].question)
            destination!.setAnswers(incomingAnswers: self.quiz!.questionAnswers[questionCounter].answers, correctAnswer: self.quiz!.questionAnswers[questionCounter].correctAnswer, counter: self.questionCounter + 1, quizLength: self.quiz!.questionAnswers.count, correctCount: self.correctCount)
            destination!.setQuiz(incomingQuiz: self.quiz!)
        case "FinishSegue":
            let destination = segue.destination as? FinishViewController
            destination!.incoming(incomingCorrect: self.correctCount, incomingLength: self.quiz!.questionAnswers.count)
        case "AnswerHomeSegue":
            let destination = segue.destination as? ViewController
            destination?.setLoaded(load: true)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
