//
//  ViewController.swift
//  iQuiz
//
//  Created by Govind Pillai on 2/10/18.
//  Copyright © 2018 info.u.washington.edu.govindg. All rights reserved.
//

import UIKit

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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var quizTable: UITableView!
    var quizzes : [Quiz] = []
    var storedURL : String = ""
    var loaded : Bool = false
    
    func setLoaded(load: Bool) {
        self.loaded = load
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberofRowsInSection called")
        return self.quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("We are being asked for indexPath \(indexPath)")
        let index = indexPath.row
        let quiz = self.quizzes[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = quiz.name
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = UIImage(named: ("\(quiz.image)"))
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerSettingsBundle()
        self.viewDidAppear(true)
        // Do any additional setup after loading the view, typically from a nib.
        if let url = UserDefaults.standard.string(forKey: "quiz_url") {
            self.storedURL = url
        }
        if !loaded {
            if self.storedURL.count > 0 {
                downloadJSON()
            } else {
                loadFromLocalStorage()
            }
        } else {
            loadFromLocalStorage()
        }
        quizTable.dataSource = self
        quizTable.delegate = self
        quizTable.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Reachability.isConnectedToNetwork() {
            let networkAlert = UIAlertController(title: "No Network Connection", message: "Please connect your device to a WiFi Access Point. Using local storage.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                networkAlert.dismiss(animated: true)
            })
            self.present(networkAlert, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func settingsPushed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Settings", message: "Settings for the quiz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        alert.addTextField { (textField) in
            textField.text = self.storedURL
        }
        
        alert.addAction(UIAlertAction(title: "Check Now", style: .default) { _ in
            let alertURL = (alert.textFields?[0].text!)!
            if alertURL.count > 0 {
                self.loaded = false
                self.storedURL = alert.textFields![0].text!
                self.downloadJSON()
            }
        })
        
        self.present(alert, animated: true, completion: {
            NSLog("The completion handler fired")
        })
    }
    
    func registerSettingsBundle(){
        let appDefaults = ["quiz_url": "https://tednewardsandbox.site44.com/questions.json"]
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
    }
    
    func downloadJSON() {
        let url = URL(string: self.storedURL)
        if Reachability.isConnectedToNetwork() {
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    let jsonAlert = UIAlertController(title: "Error", message: "JSON Download failed. Using Local Storage.", preferredStyle: .alert)
                    jsonAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        jsonAlert.dismiss(animated: true)
                    })
                    self.present(jsonAlert, animated: true)
                    self.loadFromLocalStorage()
                } else {
                    do {
                        if let dat = data {
                            let json = try JSONSerialization.jsonObject(with: dat, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL = documentsDirectory.appendingPathComponent("questions.json")
                            try json.write(to: fileURL)
                            self.getData(jsonObj: json)
                        }
                    } catch {
                        let jsonAlert = UIAlertController(title: "Error", message: "JSON Download failed. Using Local Storage.", preferredStyle: .alert)
                        jsonAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                            jsonAlert.dismiss(animated: true)
                        })
                        self.present(jsonAlert, animated: true)
                        self.loadFromLocalStorage()
                    }
                }
            }.resume()
        } else {
            let networkAlert = UIAlertController(title: "No Network Connection", message: "Please connect your device to a WiFi Access Point. Loading local JSON for now.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                networkAlert.dismiss(animated: true)
            })
            self.present(networkAlert, animated: true)
            self.loadFromLocalStorage()
        }
        self.loaded = true
    }
    
    func getData(jsonObj : NSArray) {
        self.quizzes.removeAll()
        var q_a: [QuestionAnswer] = []
        for i in 0...jsonObj.count - 1 {
            let quiz = jsonObj[i] as! [String : Any]
            let questions = quiz["questions"] as! [[String: Any]]
            for question in questions {
                q_a.append(QuestionAnswer(question: question["text"] as! String, answers: question["answers"] as! [String], correctAnswer: Int(question["answer"] as! String)!))
            }
            self.quizzes.append(Quiz(name: quiz["title"] as! String, description: quiz["desc"] as! String, image: "\(quiz["title"]!).png", questionAnswers: q_a))
            q_a.removeAll()
        }
        
        DispatchQueue.main.async {
            self.quizTable.reloadData()
        }
    }
    
    func loadFromLocalStorage() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path = documentsDirectory.appendingPathComponent("questions.json")
        let jsonData = NSArray(contentsOf: path)
        getData(jsonObj: jsonData!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let count = 1
        switch segue.identifier! {
        case "QuestionSegue":
            let destination = segue.destination as! QuestionViewController
            let cell = sender as! UITableViewCell; let indexPath = quizTable.indexPath(for: cell)
            let quiz = self.quizzes[(indexPath?.row)!]
            destination.setQuestionLabel(incoming: quiz.questionAnswers[count - 1].question)
            destination.setAnswers(incomingAnswers: quiz.questionAnswers[count - 1].answers, correctAnswer: quiz.questionAnswers[count - 1].correctAnswer, counter: count, quizLength: quiz.questionAnswers.count)
            destination.setQuiz(incomingQuiz: quiz)
        default:
            NSLog("Unknown segue identifier -- " + segue.identifier!)
        }
    }
}

