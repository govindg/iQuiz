//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/13/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var buttons: UIButton!
    public var questionText: String! = nil
    public var answers: [String]! = []
    public var correctAnswer: Int = -1
    
    func setQuestionLabel(incoming: String) {
        self.questionText = incoming
    }
    
    func setAnswers(incomingAnswers: [String], correctAnswer: Int) {
        self.answers = incomingAnswers
        self.correctAnswer = correctAnswer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.questionText != nil && self.answers != nil {
            questionLabel!.text = self.questionText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
