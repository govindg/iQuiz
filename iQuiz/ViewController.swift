//
//  ViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/10/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var quizTable: UITableView!
    var quizzes : [Quiz]? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberofRowsInSection called")
        return quizzes!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("We are being asked for indexPath \(indexPath)")
        let index = indexPath.row
        let quiz = quizzes![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = quiz.name
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = UIImage(named: ("\(quiz.image)"))
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        quizzes = UIApplication.shared.quizRepository.getQuizzes()
        quizTable.dataSource = self
        quizTable.delegate = self
        quizTable.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingsPushed(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { _ in
            NSLog("\"OK\" pressed.")
        }))
        self.present(alert, animated: true, completion: {
            NSLog("The completion handler fired")
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let count = 1
        switch segue.identifier! {
        case "QuestionSegue":
            let destination = segue.destination as! QuestionViewController
            let cell = sender as! UITableViewCell; let indexPath = quizTable.indexPath(for: cell)
            let quiz = quizzes![(indexPath?.row)!]
            destination.setQuestionLabel(incoming: quiz.questionAnswers[count - 1].question)
            destination.setAnswers(incomingAnswers: quiz.questionAnswers[count - 1].answers, correctAnswer: quiz.questionAnswers[count - 1].correctAnswer, counter: count, quizLength: quiz.questionAnswers.count)
            destination.setQuiz(incomingQuiz: quiz)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
    
}

